import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:pdf/widgets.dart' as pw;
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_format.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_sizing.dart';
import 'package:paperless_mobile/features/scanner/processing/pixel_crop.dart';
import 'package:paperless_mobile/features/scanner/processing/white_balance.dart';

/// Assembles one or more scanned page image files (in order) into a single
/// marginless PDF.
///
/// Scanner uploads are always assembled as a PDF this way, including the
/// single-page case — there is no separate "raw image" upload path for
/// scans. Each source page/segment is decoded, prepared and encoded one at
/// a time, with native/decoded resources disposed deterministically (in
/// `finally` blocks) as soon as they are no longer needed. For an
/// unsegmented (ordinary) page, peak native memory for that file stays
/// bounded to roughly one page at a time. For a segmented (extreme
/// long/narrow) page, the full decoded source additionally stays resident
/// for the duration of that file's segment loop — this is unavoidable,
/// since every segment is cropped from it — so peak memory for that file
/// is roughly "one full decoded source plus one segment" rather than one
/// page alone. Across files, only one file's resources are ever resident
/// at a time.
///
/// Intended to be run via `compute(...)` (as `scanner_page.dart` already
/// does for this function), reusing the existing isolate/compute pattern
/// for this CPU-heavy work rather than introducing a new concurrency
/// mechanism.
///
/// Residual, acknowledged limitation: [pw.Document.save] itself still
/// materializes the *entire* resulting PDF as a single `Uint8List` — the
/// `pdf` package does not stream its output. This function only bounds the
/// size of the *compressed input* to that call (via the per-page pixel
/// budget in `pdf_page_sizing.dart` and the fixed [documentJpegQuality]),
/// it cannot make `pw.Document.save()` itself stream.
///
/// Throws an [ArgumentError] if [filePaths] is empty — there is no such
/// thing as a zero-page PDF here, and silently producing an empty document
/// would only hide a caller bug.
Future<Uint8List> assembleDocumentPdfBytes(List<String> filePaths) async {
  if (filePaths.isEmpty) {
    throw ArgumentError.value(
      filePaths,
      'filePaths',
      'must not be empty; a PDF requires at least one page',
    );
  }
  final doc = pw.Document();
  for (final filePath in filePaths) {
    final pages = await preparePdfPagesForFile(filePath);
    for (final page in pages) {
      doc.addPage(
        pw.Page(
          pageFormat: pdfPageFormatForRaster(page.pixelWidth, page.pixelHeight),
          margin: pw.EdgeInsets.zero,
          build: (context) =>
              pw.Image(pw.MemoryImage(page.bytes), fit: pw.BoxFit.fill),
        ),
      );
    }
  }
  return doc.save();
}

/// One fully prepared raster, ready to become a single marginless PDF page.
///
/// Public (rather than file-private) so it — and [preparePdfPagesForFile] —
/// can be exercised directly by tests without needing to parse the final
/// assembled PDF bytes.
class PreparedPdfPage {
  final Uint8List bytes;
  final int pixelWidth;
  final int pixelHeight;

  const PreparedPdfPage({
    required this.bytes,
    required this.pixelWidth,
    required this.pixelHeight,
  });
}

/// Prepares all PDF page rasters for a single source file.
///
/// Applies, in order: pixel-budgeted (down-only) resizing or long-axis
/// segmentation (see `pdf_page_sizing.dart`), then a conservative automatic
/// white balance on color pages only (see `white_balance.dart`).
/// Grayscale/black & white pages are always left photometrically
/// unchanged. When a page already complies with the pixel budget and (for
/// color pages) white balance made no correction, the original file bytes
/// are reused verbatim instead of being re-encoded, to avoid an
/// unnecessary lossy JPEG round-trip and to keep true black & white pages
/// losslessly PNG-encoded.
Future<List<PreparedPdfPage>> preparePdfPagesForFile(String filePath) async {
  final originalBytes = await File(filePath).readAsBytes();
  final isSourcePng = filePath.toLowerCase().endsWith('.png');
  final source = cv4.imdecode(originalBytes, cv4.IMREAD_UNCHANGED);
  try {
    if (source.cols <= 0 || source.rows <= 0) {
      throw FormatException(
        'Could not decode a valid image from file "$filePath": '
        'decoded size is ${source.cols}x${source.rows}',
      );
    }

    final isColor = source.channels >= 3;
    final size = Size(source.cols.toDouble(), source.rows.toDouble());
    final plan = planPdfPageSizing(size);

    // Only fetched (and only once) when segmentation is actually needed;
    // every segment's crop is taken from this same cached buffer instead
    // of re-reading `source.data` (a fresh native->Dart copy) per segment.
    final sourcePixels = plan.isSegmented ? source.data : null;

    final pages = <PreparedPdfPage>[];
    for (final segment in plan.segments) {
      // A segmented page is always an owned crop of the original decoded
      // source (see `sourcePixels` above). An unsegmented page instead
      // works directly on `source` itself — no upfront clone — since
      // there is only ever one segment in that case and `source` is
      // already guaranteed to be disposed exactly once by the outer
      // `finally` below. `ownsWorking` tracks whether *this* loop
      // iteration is responsible for disposing `working` (i.e. `working`
      // is a distinct Mat instance from `source`), so `source` itself is
      // never disposed here and is never used after its single disposal.
      cv4.Mat working;
      var ownsWorking = false;
      if (plan.isSegmented) {
        working = _cropMat(
          sourcePixels!,
          sourceWidth: source.cols,
          sourceHeight: source.rows,
          channels: source.channels,
          type: source.type,
          rect: segment.sourceRect,
        );
        ownsWorking = true;
      } else {
        working = source;
      }
      // Whether `working`'s pixels have diverged from the original file's
      // encoded bytes and therefore require a fresh (lossy, for color
      // pages) encode.
      var needsReencode = plan.isSegmented;
      try {
        final beforeResize = (working.cols, working.rows);
        final resized = await _resizeIfNeeded(working, segment.targetSize);
        if (!identical(resized, working)) {
          if (ownsWorking) {
            working.dispose();
          }
          working = resized;
          ownsWorking = true;
        }
        if ((working.cols, working.rows) != beforeResize) {
          needsReencode = true;
        }

        if (isColor) {
          final balance = applyConservativeWhiteBalance(
            working.data,
            width: working.cols,
            height: working.rows,
            channels: working.channels,
            sampleStride: _sampleStrideFor(working.cols, working.rows),
          );
          if (balance.applied) {
            final corrected = cv4.Mat.fromList(
              working.rows,
              working.cols,
              working.type,
              balance.pixels,
            );
            if (ownsWorking) {
              working.dispose();
            }
            working = corrected;
            ownsWorking = true;
            needsReencode = true;
          }
        }

        final bytes = !needsReencode
            ? originalBytes
            : working.channels == 4
            ? encodeDocumentPng(working)
            : isColor
            ? encodeDocumentJpeg(working)
            : isSourcePng
            ? encodeDocumentPng(working)
            : encodeDocumentJpeg(working);

        pages.add(
          PreparedPdfPage(
            bytes: bytes,
            pixelWidth: working.cols,
            pixelHeight: working.rows,
          ),
        );
      } finally {
        if (ownsWorking) {
          working.dispose();
        }
      }
    }
    return pages;
  } finally {
    source.dispose();
  }
}

/// Crops [rect] (in source pixel coordinates) out of a cached, previously
/// fetched interleaved pixel buffer ([sourcePixels], one full decoded copy
/// shared across every segment of the same source — see the single
/// `source.data` fetch in [preparePdfPagesForFile]) using a pure Dart byte
/// copy (see `pixel_crop.dart`) rather than relying on an uncertain native
/// ROI API, then rebuilds a [cv4.Mat] from the result. This still performs
/// one full-source-sized Dart copy per segment (the crop itself); what it
/// avoids is redundantly re-fetching the native `Mat`'s pixel data once per
/// segment on top of that.
cv4.Mat _cropMat(
  Uint8List sourcePixels, {
  required int sourceWidth,
  required int sourceHeight,
  required int channels,
  required cv4.MatType type,
  required Rect rect,
}) {
  final cropped = cropInterleavedPixels(
    sourcePixels,
    srcWidth: sourceWidth,
    srcHeight: sourceHeight,
    channels: channels,
    left: rect.left.floor(),
    top: rect.top.floor(),
    width: rect.width.ceil(),
    height: rect.height.ceil(),
  );
  return cv4.Mat.fromList(cropped.height, cropped.width, type, cropped.pixels);
}

/// Resizes [mat] to [targetSize] (down-only per `pdf_page_sizing.dart`),
/// returning a new [cv4.Mat] without disposing [mat] — disposal of
/// whichever Mat is no longer needed is the caller's responsibility, since
/// the caller (unlike this function) knows whether it currently owns
/// [mat]. Returns [mat] unchanged (same instance) when no resize is
/// actually needed.
Future<cv4.Mat> _resizeIfNeeded(cv4.Mat mat, Size targetSize) async {
  // Detect "unchanged" using rounding (not flooring) against the *exact*
  // requested target size, so a target that is numerically equal to the
  // current size (up to floating-point noise) is correctly recognized as
  // a no-op rather than spuriously floored down by one pixel.
  final roundedWidth = targetSize.width.round();
  final roundedHeight = targetSize.height.round();
  if (roundedWidth == mat.cols && roundedHeight == mat.rows) {
    return mat;
  }
  // A genuine downscale: floor (never round up) and clamp to at least 1
  // pixel per dimension, so the resulting pixel count can never exceed
  // the pixel budget it was derived from due to rounding, and never
  // degenerates to a zero-size Mat.
  final targetWidth = math.max(1, targetSize.width.floor());
  final targetHeight = math.max(1, targetSize.height.floor());
  return cv4.resizeAsync(mat, (targetWidth, targetHeight));
}

/// Picks a pixel-sampling stride for the white balance pass that keeps
/// sampling cost roughly bounded on very large rasters while remaining
/// statistically representative on typical page sizes.
int _sampleStrideFor(int width, int height) {
  const referencePixelCount = 1000000;
  final totalPixels = width * height;
  if (totalPixels <= referencePixelCount) return 1;
  final scale = math.sqrt(totalPixels / referencePixelCount);
  return scale.round().clamp(1, 8);
}
