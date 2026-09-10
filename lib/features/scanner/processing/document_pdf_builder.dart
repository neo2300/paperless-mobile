import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:pdf/widgets.dart' as pw;
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_format.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_jpeg_encoding.dart';
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
/// budget in `pdf_page_sizing.dart` and the adaptive JPEG quality ladder in
/// `pdf_page_jpeg_encoding.dart`), it cannot make `pw.Document.save()`
/// itself stream. See [assembleAndWriteDocumentPdfToFile] for the
/// upload-path variant that at least avoids re-transmitting that resulting
/// `Uint8List` across an isolate boundary.
///
/// Throws an [ArgumentError] if [filePaths] is empty — there is no such
/// thing as a zero-page PDF here, and silently producing an empty document
/// would only hide a caller bug.
Future<Uint8List> assembleDocumentPdfBytes(List<String> filePaths) async {
  final (doc, _) = await _buildDocument(filePaths);
  return doc.save();
}

/// Compute-compatible argument bundle for [assembleAndWriteDocumentPdfToFile].
///
/// A record of primitive/`String` fields, which is always safe to send
/// across the isolate boundary `compute(...)` uses.
typedef AssembleAndWritePdfRequest = ({
  List<String> filePaths,
  String outputPath,
});

/// Non-sensitive result of [assembleAndWriteDocumentPdfToFile]: the final
/// PDF's byte length and how many rasterized pages it contains.
/// Deliberately excludes the PDF bytes themselves, the source file paths,
/// and any document metadata — safe to log verbatim.
typedef AssembledPdfWriteResult = ({int byteLength, int pageCount});

/// Same page-by-page assembly as [assembleDocumentPdfBytes], but intended
/// for the upload path: run via `compute(request, assembleAndWriteDocumentPdfToFile)`
/// so this executes in a worker isolate, and write the resulting PDF bytes
/// directly to `request.outputPath` *from that same worker isolate*
/// instead of also transferring the full `Uint8List` back to the caller.
///
/// `pw.Document.save()` still materializes the whole PDF as a single
/// `Uint8List` internally — see [assembleDocumentPdfBytes]'s doc comment
/// for that residual, acknowledged limitation — but that byte list is
/// written to disk and discarded immediately, right here in the worker
/// isolate. Only [AssembledPdfWriteResult] (two integers) is ever sent back
/// across the isolate boundary, avoiding the additional full-document copy
/// the previous "assemble bytes, then write them" upload path performed.
Future<AssembledPdfWriteResult> assembleAndWriteDocumentPdfToFile(
  AssembleAndWritePdfRequest request,
) async {
  final (doc, pageCount) = await _buildDocument(request.filePaths);
  final bytes = await doc.save();
  final outputFile = File(request.outputPath);
  await outputFile.writeAsBytes(bytes, flush: true);
  return (byteLength: bytes.length, pageCount: pageCount);
}

/// Shared page-assembly loop used by both [assembleDocumentPdfBytes] and
/// [assembleAndWriteDocumentPdfToFile].
Future<(pw.Document, int)> _buildDocument(List<String> filePaths) async {
  if (filePaths.isEmpty) {
    throw ArgumentError.value(
      filePaths,
      'filePaths',
      'must not be empty; a PDF requires at least one page',
    );
  }
  final doc = pw.Document();
  var pageCount = 0;
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
      pageCount++;
    }
  }
  return (doc, pageCount);
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

  /// The JPEG quality actually selected by the adaptive ladder in
  /// `pdf_page_jpeg_encoding.dart`, or `null` when this page was PNG
  /// (lossless) or reused verbatim (no JPEG encode was performed at all).
  final int? selectedJpegQuality;

  /// How many encode calls were performed to produce [bytes] (at most 4 for
  /// the JPEG ladder, at most 2 for the lossless-PNG fallback, or 0 when
  /// [sourceBytesReused] is `true`).
  final int encodeAttempts;

  /// Whether [bytes] are the original source file's bytes, reused verbatim
  /// (no re-encode of any kind was performed).
  final bool sourceBytesReused;

  const PreparedPdfPage({
    required this.bytes,
    required this.pixelWidth,
    required this.pixelHeight,
    this.selectedJpegQuality,
    this.encodeAttempts = 0,
    this.sourceBytesReused = false,
  });
}

/// Prepares all PDF page rasters for a single source file.
///
/// Applies, in order: pixel-budgeted (down-only) resizing or long-axis
/// segmentation (see `pdf_page_sizing.dart`), then a conservative automatic
/// white balance on color pages only (see `white_balance.dart`), then a
/// format-appropriate encode:
///
///  * A page that needs no resize/white-balance correction and whose
///    original bytes are already small enough is reused verbatim (see
///    [_encodePreparedPage] for the exact thresholds), avoiding an
///    unnecessary re-encode entirely.
///  * A page with an alpha channel, or a true grayscale/black & white PNG
///    source, is always kept losslessly PNG-encoded (see
///    [_encodeLosslessPngPage]) — colored pages are never auto-converted to
///    grayscale, and a grayscale/B&W page is never lossily converted to
///    JPEG to save space.
///  * Every other page (color, or grayscale from a non-PNG source) is
///    encoded through the bounded adaptive JPEG quality ladder in
///    `pdf_page_jpeg_encoding.dart`.
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
    // Captured once, from the untouched decoded source, before any
    // segmentation/resizing — this is what keeps a long receipt's native
    // short-edge resolution intact through every later fallback downscale,
    // regardless of which segment is currently being processed.
    final nativeShortEdgePixels = math.min(size.width, size.height);
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
      // encoded bytes and therefore require a fresh re-encode.
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

        final page = await _encodePreparedPage(
          working: working,
          originalBytes: originalBytes,
          needsReencode: needsReencode,
          isColor: isColor,
          isSourcePng: isSourcePng,
          nativeShortEdgePixels: nativeShortEdgePixels,
        );
        pages.add(page);
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

/// Picks the format-appropriate encode path for one already resized/
/// white-balanced [working] raster, and decides whether the original
/// source bytes can be reused verbatim instead of re-encoding at all.
///
/// A page with an alpha channel, or a true grayscale/black & white PNG
/// source, always goes through the lossless PNG path
/// ([_encodeLosslessPngPage]); every other page goes through the adaptive
/// JPEG ladder ([encodePdfPageJpegAdaptive]) in `pdf_page_jpeg_encoding.dart`.
///
/// The verbatim-reuse threshold differs between the two paths: the JPEG
/// path reuses verbatim only up to the same soft byte target
/// ([kPdfPageJpegSoftTargetBytes]) the adaptive ladder itself targets (so
/// there is no size cliff between "reused" and "freshly encoded"), while
/// the lossless PNG path — which has no quality knob to trade against size
/// — reuses verbatim up to the more permissive advisory ceiling
/// ([kPdfPageJpegAdvisoryCeilingBytes]).
Future<PreparedPdfPage> _encodePreparedPage({
  required cv4.Mat working,
  required Uint8List originalBytes,
  required bool needsReencode,
  required bool isColor,
  required bool isSourcePng,
  required double nativeShortEdgePixels,
}) async {
  final isAlpha = working.channels == 4;
  final isLosslessPngPage = isAlpha || (isSourcePng && !isColor);

  if (isLosslessPngPage) {
    return _encodeLosslessPngPage(
      working: working,
      originalBytes: originalBytes,
      needsReencode: needsReencode,
      nativeShortEdgePixels: nativeShortEdgePixels,
    );
  }

  if (!needsReencode &&
      originalBytes.lengthInBytes <= kPdfPageJpegSoftTargetBytes) {
    return PreparedPdfPage(
      bytes: originalBytes,
      pixelWidth: working.cols,
      pixelHeight: working.rows,
      sourceBytesReused: true,
    );
  }

  final result = await encodePdfPageJpegAdaptive(
    working,
    nativeShortEdgePixels: nativeShortEdgePixels,
  );
  return PreparedPdfPage(
    bytes: result.bytes,
    pixelWidth: result.pixelWidth,
    pixelHeight: result.pixelHeight,
    selectedJpegQuality: result.quality,
    encodeAttempts: result.attempts,
  );
}

/// Encodes (or reuses) a page that must stay losslessly PNG-encoded: one
/// with an alpha channel, or a true grayscale/black & white PNG source.
///
/// If [needsReencode] is `false` and the original bytes already fit under
/// [kPdfPageJpegAdvisoryCeilingBytes], they are reused verbatim. Otherwise
/// the raster is PNG-encoded once; if that single encode's result still
/// exceeds the advisory ceiling, exactly one further (down-only) fallback
/// downscale — preserving native short edges through 1600px exactly and,
/// above that threshold, never shrinking below the 1400px OCR floor used by
/// the JPEG ladder (see `pdf_page_jpeg_encoding.dart`) — is applied and the
/// page is
/// PNG re-encoded a second (and final) time. The result is accepted
/// regardless of whether it is still above the ceiling afterwards: there
/// is no lossy fallback for a page that must remain losslessly encoded,
/// and the resolution floor needed for OCR always wins over file size.
Future<PreparedPdfPage> _encodeLosslessPngPage({
  required cv4.Mat working,
  required Uint8List originalBytes,
  required bool needsReencode,
  required double nativeShortEdgePixels,
}) async {
  if (!needsReencode &&
      originalBytes.lengthInBytes <= kPdfPageJpegAdvisoryCeilingBytes) {
    return PreparedPdfPage(
      bytes: originalBytes,
      pixelWidth: working.cols,
      pixelHeight: working.rows,
      sourceBytesReused: true,
    );
  }

  var pngMat = working;
  var ownsPngMat = false;
  var bytes = encodeDocumentPng(pngMat);
  var attempts = 1;
  if (bytes.lengthInBytes > kPdfPageJpegAdvisoryCeilingBytes) {
    final currentSize = Size(pngMat.cols.toDouble(), pngMat.rows.toDouble());
    final fallbackSize = planPdfPageFallbackDownscale(
      currentSize: currentSize,
      nativeShortEdgePixels: nativeShortEdgePixels,
    );
    final targetPixelSize = flooredPdfPageJpegPixelSize(fallbackSize);
    if (targetPixelSize != currentSize) {
      final targetWidth = targetPixelSize.width.toInt();
      final targetHeight = targetPixelSize.height.toInt();
      pngMat = await cv4.resizeAsync(pngMat, (targetWidth, targetHeight));
      ownsPngMat = true;
      bytes = encodeDocumentPng(pngMat);
      attempts = 2;
    }
  }
  try {
    return PreparedPdfPage(
      bytes: bytes,
      pixelWidth: pngMat.cols,
      pixelHeight: pngMat.rows,
      encodeAttempts: attempts,
    );
  } finally {
    if (ownsPngMat) {
      pngMat.dispose();
    }
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
