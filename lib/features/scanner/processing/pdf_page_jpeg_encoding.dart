// Adaptive JPEG encoding policy used exclusively by the PDF page
// preparation pipeline (`document_pdf_builder.dart`), as opposed to the
// fixed-quality [documentJpegQuality] used by every other scanner encoding
// call site.
//
// Real-device uploads showed that a single fixed-quality JPEG encode of a
// large (multi-megapixel) page raster can produce files large enough that
// the resulting multi-page PDF fails to be accepted for consumption by the
// Paperless server without any visible error reaching the app. This module
// implements a small, deterministic, *bounded* retry ladder instead: at
// most four (and, when a fallback downscale would not genuinely change the
// raster's pixel size, only three unique) JPEG encodes, trading quality
// (and, as a last resort, resolution) for a smaller file, while never
// upscaling and never shrinking a page below the resolution an OCR engine
// needs to still read a long receipt's native short edge. A native short
// edge at or under `kPdfPageJpegNativeShortEdgePreservationThreshold`
// (1600px) is preserved *exactly* by the fallback downscale; only above
// that threshold is it allowed to shrink toward the lower
// `kPdfPageJpegShortEdgeFloorCap` (1400px) floor.
//
// Every function here is pure (no native/OpenCV dependency) *except*
// [encodePdfPageJpegAdaptive] itself, which needs `opencv_dart` to actually
// resize/encode. The planning logic that decides *what* to try at each
// attempt is fully extracted into [planPdfPageJpegEncodeAttempts] and
// [planPdfPageFallbackDownscale] so it can be exercised deterministically
// in tests without a native toolchain.
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';

/// Soft byte-size target the adaptive ladder tries to reach. Encoding stops
/// as soon as an attempt's encoded size is at or below this target — it is
/// a "soft" target because a pathological (very high-entropy) page may
/// never reach it within the bounded number of attempts, in which case the
/// best (last) attempt is still accepted (see [kPdfPageJpegAdvisoryCeilingBytes]).
const int kPdfPageJpegSoftTargetBytes = 550 * 1024;

/// Advisory (non-enforced) upper bound used only to describe/detect a
/// pathological page that the bounded ladder could not bring under the
/// soft target. Exceeding this is accepted — never retried further —
/// because the resolution floor needed for OCR takes priority over file
/// size for such pages.
const int kPdfPageJpegAdvisoryCeilingBytes = 900 * 1024;

/// Pixel budget the ladder downscales toward, once, as its third attempt,
/// if the first two (same-resolution) quality attempts both stayed above
/// [kPdfPageJpegSoftTargetBytes].
const double kPdfPageJpegFallbackPixelBudget = 3.5e6;

/// Native short-edge threshold (in pixels), at or under which the
/// fallback downscale preserves the native short edge *exactly* — never
/// shrinking it at all, not even toward [kPdfPageJpegShortEdgeFloorCap].
/// This is what keeps a long receipt whose native short edge sits at a
/// typical "already low-ish resolution" scan (e.g. 1600px) fully intact
/// through the fallback downscale, instead of letting it be shrunk further
/// toward the (lower) floor cap just because one of its long-axis segments
/// individually still exceeds [kPdfPageJpegFallbackPixelBudget].
///
/// Only once the native short edge exceeds this threshold is
/// [kPdfPageJpegShortEdgeFloorCap] used as the (lower) floor instead — see
/// [planPdfPageFallbackDownscale].
const double kPdfPageJpegNativeShortEdgePreservationThreshold = 1600;

/// Absolute short-edge floor (in pixels) the fallback downscale must never
/// go below, regardless of how small [kPdfPageJpegFallbackPixelBudget]
/// would otherwise push it. This floor only applies once the native short
/// edge exceeds [kPdfPageJpegNativeShortEdgePreservationThreshold]; at or
/// under that threshold, the native short edge is preserved exactly
/// instead (see [planPdfPageFallbackDownscale]) — so a page whose native
/// short edge is already at/under the preservation threshold is never
/// downscaled past its own native short edge (never upscaled either).
const double kPdfPageJpegShortEdgeFloorCap = 1400;

/// The JPEG quality used by the ladder's first attempt.
const int kPdfPageJpegQualityFirst = 84;

/// The JPEG quality used by the ladder's second attempt (same resolution
/// as the first) and third attempt (after the one-time fallback
/// downscale).
const int kPdfPageJpegQualitySecond = 74;

/// The JPEG quality used by the ladder's fourth and final attempt. This is
/// the lowest quality the ladder will ever use — it never goes lower,
/// accepting whatever size results instead.
const int kPdfPageJpegQualityFinal = 64;

/// One planned attempt of the bounded PDF-page JPEG encode ladder.
///
/// Purely descriptive (no bytes/Mats involved) so the full ladder can be
/// planned and asserted on without any native dependency — see
/// [planPdfPageJpegEncodeAttempts].
class PdfPageJpegEncodeAttemptPlan {
  final int attemptNumber;
  final int quality;
  final Size targetSize;
  final bool isDownscaled;

  const PdfPageJpegEncodeAttemptPlan({
    required this.attemptNumber,
    required this.quality,
    required this.targetSize,
    required this.isDownscaled,
  });

  @override
  String toString() =>
      'PdfPageJpegEncodeAttemptPlan(#$attemptNumber, quality: $quality, '
      'targetSize: $targetSize, isDownscaled: $isDownscaled)';
}

/// Plans a single further (down-only) proportional downscale of an
/// already pixel-budgeted raster toward [fallbackPixelBudget].
///
/// Never upscales. The short edge is never shrunk below a floor that
/// depends on how [nativeShortEdgePixels] compares to
/// [nativeShortEdgePreservationThreshold]: at or under the threshold, the
/// native short edge is preserved *exactly* (the floor is
/// `nativeShortEdgePixels` itself); above it, [shortEdgeFloorCap] is used
/// as the floor instead. This is what keeps a long receipt's native
/// short-edge resolution intact even when one of its long-axis segments
/// individually still needs a further size reduction to hit a byte-size
/// target — and what stops an oversized lossless PNG page (see
/// `document_pdf_builder.dart`) from being shrunk below what OCR needs,
/// even if it stays above the advisory byte ceiling as a result.
///
/// Returns [currentSize] unchanged when it already fits [fallbackPixelBudget]
/// or when its short edge is already at (or under) the floor.
Size planPdfPageFallbackDownscale({
  required Size currentSize,
  required double nativeShortEdgePixels,
  double fallbackPixelBudget = kPdfPageJpegFallbackPixelBudget,
  double shortEdgeFloorCap = kPdfPageJpegShortEdgeFloorCap,
  double nativeShortEdgePreservationThreshold =
      kPdfPageJpegNativeShortEdgePreservationThreshold,
}) {
  final width = currentSize.width;
  final height = currentSize.height;
  assert(width > 0 && height > 0, 'currentSize must be positive');
  assert(nativeShortEdgePixels > 0, 'nativeShortEdgePixels must be positive');

  final totalPixels = width * height;
  if (totalPixels <= fallbackPixelBudget) {
    return currentSize;
  }

  final currentShortEdge = math.min(width, height);
  final floor = nativeShortEdgePixels <= nativeShortEdgePreservationThreshold
      ? nativeShortEdgePixels
      : shortEdgeFloorCap;
  if (currentShortEdge <= floor) {
    return currentSize;
  }

  var scale = math.sqrt(fallbackPixelBudget / totalPixels);
  final minScaleForFloor = floor / currentShortEdge;
  // Clamp the pixel-budget-driven scale so it never pushes the short edge
  // below the floor — but never let this clamp *upscale* beyond the
  // current size (`min(..., 1.0)`).
  scale = math.max(scale, math.min(minScaleForFloor, 1.0));

  return Size(width * scale, height * scale);
}

/// Floors [value] to an integer pixel dimension, clamped to at least 1.
///
/// Used identically by both the planning stage ([planPdfPageJpegEncodeAttempts],
/// deciding whether a fallback downscale is a *genuine* size change worth
/// its own attempts) and the actual resize execution stage
/// ([encodePdfPageJpegAdaptive], deciding whether a native resize call is
/// actually needed) so the two can never disagree — e.g. due to
/// floating-point noise in [planPdfPageFallbackDownscale]'s scale
/// computation — and therefore never plan (or perform) a spurious extra
/// resize/encode of pixel-identical dimensions.
int flooredPdfPageJpegPixelDimension(double value) =>
    math.max(1, value.floor());

/// Converts a planned floating-point size to the exact integer pixel size
/// used by OpenCV. Both attempt planning and resize execution use this helper.
Size flooredPdfPageJpegPixelSize(Size size) => Size(
  flooredPdfPageJpegPixelDimension(size.width).toDouble(),
  flooredPdfPageJpegPixelDimension(size.height).toDouble(),
);

/// Plans the deterministic, bounded PDF-page JPEG encode ladder for a
/// raster of [rasterSize] (the size already produced by
/// `pdf_page_sizing.dart`'s pixel-budget/segmentation planning).
///
/// Always plans the first two attempts at [rasterSize] itself (qualities
/// [kPdfPageJpegQualityFirst] then [kPdfPageJpegQualitySecond]). Whether a
/// 3rd/4th attempt follows depends on whether
/// [planPdfPageFallbackDownscale] actually produces a *genuinely* smaller
/// integer pixel size (compared using [flooredPdfPageJpegPixelDimension],
/// the same comparison [encodePdfPageJpegAdaptive] uses to decide whether
/// to actually resize):
///
///  * If it does not — e.g. the raster already fits [fallbackPixelBudget],
///    or its native short edge is already at the floor the fallback
///    downscale would otherwise respect — exactly **three** attempts are
///    planned: qualities [kPdfPageJpegQualityFirst],
///    [kPdfPageJpegQualitySecond], [kPdfPageJpegQualityFinal], all at
///    [rasterSize]. A 4th attempt would only ever duplicate the 3rd (same
///    size, and quality [kPdfPageJpegQualitySecond] would duplicate the
///    2nd) — planning it would be a wasted, pixel-identical re-encode.
///  * If it does, exactly **four** attempts are planned: the 3rd
///    (quality [kPdfPageJpegQualitySecond]) and 4th (quality
///    [kPdfPageJpegQualityFinal]) both target the genuinely smaller
///    downscaled size.
///
/// Attempt numbers are always sequential starting at 1, regardless of
/// which of the two shapes above is planned.
///
/// Purely a planning function: it never touches actual pixels or bytes,
/// which makes the ladder's shape (qualities, target sizes, attempt count)
/// fully unit-testable without a native toolchain.
List<PdfPageJpegEncodeAttemptPlan> planPdfPageJpegEncodeAttempts({
  required Size rasterSize,
  required double nativeShortEdgePixels,
  double fallbackPixelBudget = kPdfPageJpegFallbackPixelBudget,
  double shortEdgeFloorCap = kPdfPageJpegShortEdgeFloorCap,
  double nativeShortEdgePreservationThreshold =
      kPdfPageJpegNativeShortEdgePreservationThreshold,
}) {
  final currentPixelSize = flooredPdfPageJpegPixelSize(rasterSize);
  final downscaledSize = planPdfPageFallbackDownscale(
    currentSize: currentPixelSize,
    nativeShortEdgePixels: nativeShortEdgePixels,
    fallbackPixelBudget: fallbackPixelBudget,
    shortEdgeFloorCap: shortEdgeFloorCap,
    nativeShortEdgePreservationThreshold: nativeShortEdgePreservationThreshold,
  );
  // Compare using the exact same floored (min-1) integer pixel dimensions
  // the actual resize execution uses (see encodePdfPageJpegAdaptive), so a
  // fallback size that differs from rasterSize only by floating-point
  // noise — but floors to the identical integer pixel size — is correctly
  // treated as "no genuine downscale" rather than planning (and then
  // skipping the resize for) a spurious, pixel-duplicate extra attempt.
  final downscaledPixelSize = flooredPdfPageJpegPixelSize(downscaledSize);
  final isGenuinelyDownscaled = downscaledPixelSize != currentPixelSize;

  final attempts = <PdfPageJpegEncodeAttemptPlan>[
    PdfPageJpegEncodeAttemptPlan(
      attemptNumber: 1,
      quality: kPdfPageJpegQualityFirst,
      targetSize: currentPixelSize,
      isDownscaled: false,
    ),
    PdfPageJpegEncodeAttemptPlan(
      attemptNumber: 2,
      quality: kPdfPageJpegQualitySecond,
      targetSize: currentPixelSize,
      isDownscaled: false,
    ),
  ];

  if (isGenuinelyDownscaled) {
    attempts.add(
      PdfPageJpegEncodeAttemptPlan(
        attemptNumber: 3,
        quality: kPdfPageJpegQualitySecond,
        targetSize: downscaledPixelSize,
        isDownscaled: true,
      ),
    );
    attempts.add(
      PdfPageJpegEncodeAttemptPlan(
        attemptNumber: 4,
        quality: kPdfPageJpegQualityFinal,
        targetSize: downscaledPixelSize,
        isDownscaled: true,
      ),
    );
  } else {
    attempts.add(
      PdfPageJpegEncodeAttemptPlan(
        attemptNumber: 3,
        quality: kPdfPageJpegQualityFinal,
        targetSize: currentPixelSize,
        isDownscaled: false,
      ),
    );
  }

  return attempts;
}

/// The outcome of [encodePdfPageJpegAdaptive]: the accepted JPEG bytes
/// together with metadata sufficient for deterministic tests and
/// diagnostics, without retaining every intermediate attempt's buffer.
class PdfPageJpegEncodeResult {
  final Uint8List bytes;
  final int quality;
  final int attempts;
  final int pixelWidth;
  final int pixelHeight;

  const PdfPageJpegEncodeResult({
    required this.bytes,
    required this.quality,
    required this.attempts,
    required this.pixelWidth,
    required this.pixelHeight,
  });
}

/// Runs the bounded PDF-page JPEG encode ladder (see
/// [planPdfPageJpegEncodeAttempts]) against [image], accepting the first
/// attempt whose encoded size is at or below [softTargetBytes], or the
/// final attempt's result otherwise (3 attempts when no genuine fallback
/// downscale applies, 4 when it does — see [planPdfPageJpegEncodeAttempts]).
///
/// Does not dispose [image] itself (ownership stays with the caller,
/// mirroring `document_pdf_builder.dart`'s existing Mat-ownership
/// convention) but does dispose any intermediate resized Mat it creates
/// internally as soon as it is no longer needed, so at most one extra
/// native Mat is ever resident at a time on top of [image].
Future<PdfPageJpegEncodeResult> encodePdfPageJpegAdaptive(
  cv4.Mat image, {
  required double nativeShortEdgePixels,
  int softTargetBytes = kPdfPageJpegSoftTargetBytes,
  double fallbackPixelBudget = kPdfPageJpegFallbackPixelBudget,
  double shortEdgeFloorCap = kPdfPageJpegShortEdgeFloorCap,
}) async {
  final rasterSize = Size(image.cols.toDouble(), image.rows.toDouble());
  final attempts = planPdfPageJpegEncodeAttempts(
    rasterSize: rasterSize,
    nativeShortEdgePixels: nativeShortEdgePixels,
    fallbackPixelBudget: fallbackPixelBudget,
    shortEdgeFloorCap: shortEdgeFloorCap,
  );

  var current = image;
  var ownsCurrent = false;
  late Uint8List bestBytes;
  var bestQuality = attempts.first.quality;
  var bestWidth = current.cols;
  var bestHeight = current.rows;
  var attemptsMade = 0;
  try {
    for (final attempt in attempts) {
      attemptsMade++;
      // Uses the exact same floored (min-1) integer pixel dimensions
      // [planPdfPageJpegEncodeAttempts] used to decide whether this
      // attempt's fallback downscale was a *genuine* size change, so the
      // two can never disagree and this can never perform a spurious
      // pixel-identical resize.
      final targetPixelSize = flooredPdfPageJpegPixelSize(attempt.targetSize);
      final targetWidth = targetPixelSize.width.toInt();
      final targetHeight = targetPixelSize.height.toInt();
      if (targetWidth != current.cols || targetHeight != current.rows) {
        final resized = await cv4.resizeAsync(current, (
          targetWidth,
          targetHeight,
        ));
        if (ownsCurrent) {
          current.dispose();
        }
        current = resized;
        ownsCurrent = true;
      }
      bestBytes = encodeDocumentJpeg(current, quality: attempt.quality);
      bestQuality = attempt.quality;
      bestWidth = current.cols;
      bestHeight = current.rows;
      if (bestBytes.lengthInBytes <= softTargetBytes) {
        break;
      }
    }
  } finally {
    if (ownsCurrent) {
      current.dispose();
    }
  }

  return PdfPageJpegEncodeResult(
    bytes: bestBytes,
    quality: bestQuality,
    attempts: attemptsMade,
    pixelWidth: bestWidth,
    pixelHeight: bestHeight,
  );
}
