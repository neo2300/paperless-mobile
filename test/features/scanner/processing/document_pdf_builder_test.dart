// These tests exercise the native OpenCV (`opencv_dart`) code path and
// therefore require a working native asset build (a `cmake` toolchain on
// PATH). If that is unavailable in a given environment, prefer the pure,
// OpenCV-free tests in `pdf_page_sizing_test.dart`, `white_balance_test.dart`
// and `pixel_crop_test.dart`, which cover the same core geometry/photometry
// logic without any native dependency.
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';
import 'package:paperless_mobile/features/scanner/processing/document_pdf_builder.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_jpeg_encoding.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_sizing.dart';
import 'package:path/path.dart' as p;

Future<File> _writeJpeg(
  Directory dir,
  String name,
  Uint8List bgrBytes,
  int width,
  int height,
) async {
  final mat = cv4.Mat.fromList(height, width, cv4.MatType.CV_8UC3, bgrBytes);
  try {
    final encoded = encodeDocumentJpeg(mat);
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(encoded);
    return file;
  } finally {
    mat.dispose();
  }
}

Future<File> _writePng(
  Directory dir,
  String name,
  Uint8List grayBytes,
  int width,
  int height,
) async {
  final mat = cv4.Mat.fromList(height, width, cv4.MatType.CV_8UC1, grayBytes);
  try {
    final encoded = encodeDocumentPng(mat);
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(encoded);
    return file;
  } finally {
    mat.dispose();
  }
}

Uint8List _solidColorBgr(int width, int height, int b, int g, int r) {
  final pixels = Uint8List(width * height * 3);
  for (var i = 0; i < pixels.length; i += 3) {
    pixels[i] = b;
    pixels[i + 1] = g;
    pixels[i + 2] = r;
  }
  return pixels;
}

/// Deterministic (fixed-seed) high-entropy *color* pixels: every channel
/// of every pixel is independently random, which JPEG compresses poorly —
/// this is what forces the adaptive JPEG ladder in
/// `pdf_page_jpeg_encoding.dart` to exhaust every applicable attempt
/// (rather than being accepted on the very first, highest-quality one, as
/// a solid/near-solid color fixture would be).
Uint8List _highEntropyBgr(int width, int height, {int seed = 4242}) {
  final random = Random(seed);
  final pixels = Uint8List(width * height * 3);
  for (var i = 0; i < pixels.length; i++) {
    pixels[i] = random.nextInt(256);
  }
  return pixels;
}

/// A deliberately difficult receipt fixture with deterministic photographic
/// texture plus dark text strokes. The strong texture keeps it above the JPEG
/// soft target while the strokes make it receipt-shaped rather than a plain
/// random-color block.
Uint8List _noisyTexturedReceiptBgr(int width, int height, {int seed = 4242}) {
  final pixels = _highEntropyBgr(width, height, seed: seed);
  for (var line = 0; line < 36; line++) {
    final top = ((line + 1) * height / 40).floor();
    final lineHeight = (height ~/ 500).clamp(2, 8);
    final right = width - width ~/ (line.isEven ? 8 : 3);
    for (var y = top; y < min(height, top + lineHeight); y++) {
      for (var x = width ~/ 10; x < right; x++) {
        if ((x + y + line) % 11 != 0) {
          final index = (y * width + x) * 3;
          pixels[index] = 18;
          pixels[index + 1] = 18;
          pixels[index + 2] = 18;
        }
      }
    }
  }
  return pixels;
}

/// A deterministic "realistic photographed document" fixture: a mostly
/// bright, mildly unevenly-lit (gradient) background with low-amplitude
/// per-pixel sensor noise and a handful of dark, slightly jittery
/// horizontal "text stroke" bands — standing in for a phone-camera photo
/// of a printed page. This compresses moderately well (unlike a flat
/// solid color, but far better than high-entropy noise), which is the
/// point: it is meant to exercise the adaptive ladder the way an actual
/// scanned page does.
Uint8List _realisticPhotographedDocumentBgr(
  int width,
  int height, {
  int seed = 7,
}) {
  final random = Random(seed);
  final pixels = Uint8List(width * height * 3);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final i = (y * width + x) * 3;
      // Mild lighting gradient (brighter top-left, slightly dimmer
      // bottom-right), staying within a realistic "paper white" range.
      final gradient = 245 - ((x + y) * 20 / (width + height)).round();
      // Low-amplitude per-pixel sensor noise.
      final noise = random.nextInt(9) - 4;
      final value = (gradient + noise).clamp(0, 255);
      pixels[i] = value;
      pixels[i + 1] = value;
      pixels[i + 2] = value;
    }
  }
  // A handful of dark horizontal "text stroke" bands, standing in for
  // lines of printed text, with per-pixel jitter/gaps so they are not a
  // perfectly flat (unrealistically compressible) color.
  for (var band = 0; band < 20; band++) {
    final top = (height * (band + 1) / 24).floor();
    final bandHeight = (height ~/ 200).clamp(1, height);
    for (var y = top; y < (top + bandHeight).clamp(0, height); y++) {
      final rowStart = y * width * 3;
      for (var x = width ~/ 10; x < width - (width ~/ 10); x++) {
        if (random.nextDouble() < 0.7) {
          final i = rowStart + x * 3;
          final value = (30 + random.nextInt(20)).clamp(0, 255);
          pixels[i] = value;
          pixels[i + 1] = value;
          pixels[i + 2] = value;
        }
      }
    }
  }
  return pixels;
}

/// Deterministic (fixed-seed) high-entropy grayscale pixels: PNG (and
/// JPEG) both compress this poorly, which is what forces the "oversized"
/// fallback paths in `document_pdf_builder.dart` to actually trigger.
Uint8List _highEntropyGray(int width, int height, {int seed = 4242}) {
  final random = Random(seed);
  final pixels = Uint8List(width * height);
  for (var i = 0; i < pixels.length; i++) {
    pixels[i] = random.nextInt(256);
  }
  return pixels;
}

Future<File> _writePngRgba(
  Directory dir,
  String name,
  Uint8List rgbaBytes,
  int width,
  int height,
) async {
  final mat = cv4.Mat.fromList(height, width, cv4.MatType.CV_8UC4, rgbaBytes);
  try {
    final encoded = encodeDocumentPng(mat);
    final file = File(p.join(dir.path, name));
    await file.writeAsBytes(encoded);
    return file;
  } finally {
    mat.dispose();
  }
}

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('pdf_builder_test_');
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('reuses original bytes verbatim for an already-compliant color page '
      'with no white-balance correction needed', () async {
    // A mid-tone, non-neutral color: never qualifies as a bright/neutral
    // white-balance sample, so no correction — and therefore no
    // re-encode — should happen.
    final pixels = _solidColorBgr(200, 150, 90, 110, 130);
    final file = await _writeJpeg(tempDir, 'page.jpg', pixels, 200, 150);
    final originalBytes = await file.readAsBytes();

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    expect(pages.single.pixelWidth, 200);
    expect(pages.single.pixelHeight, 150);
    expect(pages.single.bytes, equals(originalBytes));
    expect(pages.single.sourceBytesReused, isTrue);
    expect(pages.single.encodeAttempts, 0);
    expect(pages.single.selectedJpegQuality, isNull);
  });

  test('reuses original bytes verbatim (losslessly) for an already-compliant '
      'black & white PNG page', () async {
    final pixels = Uint8List(120 * 90);
    for (var i = 0; i < pixels.length; i++) {
      pixels[i] = i.isEven ? 255 : 0;
    }
    final file = await _writePng(tempDir, 'page.png', pixels, 120, 90);
    final originalBytes = await file.readAsBytes();

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    expect(pages.single.pixelWidth, 120);
    expect(pages.single.pixelHeight, 90);
    expect(pages.single.bytes, equals(originalBytes));
    expect(pages.single.sourceBytesReused, isTrue);
  });

  test('resizes and re-encodes (losslessly, PNG) an oversized black & white '
      'page whose lossless encoding exceeds the advisory ceiling despite '
      'already-compliant dimensions, accepting the final result', () async {
    // Chosen so its own pixel count (3.74MP) exceeds the 3.5MP fallback
    // budget the oversized-PNG path downscales toward, while its short
    // edge (1700) comfortably exceeds the 1400px floor — and so that
    // high-entropy "grayscale" content encodes far larger than the 900 KiB
    // advisory ceiling, forcing the fallback path to actually trigger.
    const width = 2200;
    const height = 1700;
    final pixels = _highEntropyGray(width, height);
    final file = await _writePng(tempDir, 'noisy.png', pixels, width, height);
    final originalBytes = await file.readAsBytes();
    expect(
      originalBytes.lengthInBytes,
      greaterThan(kPdfPageJpegAdvisoryCeilingBytes),
      reason: 'test fixture must actually be oversized to be meaningful',
    );

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    final page = pages.single;
    expect(page.sourceBytesReused, isFalse);
    // A real (down-only) fallback downscale happened.
    expect(page.pixelWidth, lessThan(width));
    expect(page.pixelHeight, lessThan(height));
    // Never below the short-edge floor.
    expect(page.pixelHeight, greaterThanOrEqualTo(1400));
    // Still losslessly PNG-encoded (PNG magic bytes), never converted to
    // a lossy JPEG.
    expect(page.bytes[0], 0x89);
    expect(page.bytes[1], 0x50); // 'P'
    expect(page.encodeAttempts, 2);
    // Accepted even if still above the advisory ceiling afterwards — no
    // lossy fallback exists for a page that must remain losslessly
    // encoded, and the resolution floor needed for OCR wins over size.
    expect(page.bytes, isNotEmpty);
  });

  test('keeps a page with an alpha channel losslessly PNG-encoded, never '
      'converting it to JPEG', () async {
    const width = 150;
    const height = 100;
    final pixels = Uint8List(width * height * 4);
    for (var i = 0; i < pixels.length; i += 4) {
      pixels[i] = 10; // R
      pixels[i + 1] = 200; // G
      pixels[i + 2] = 30; // B
      pixels[i + 3] = (i ~/ 4) % 256; // varying alpha
    }
    final file = await _writePngRgba(
      tempDir,
      'alpha.png',
      pixels,
      width,
      height,
    );
    final originalBytes = await file.readAsBytes();

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    final page = pages.single;
    expect(page.pixelWidth, width);
    expect(page.pixelHeight, height);
    expect(page.bytes, equals(originalBytes));
    expect(page.sourceBytesReused, isTrue);

    final decoded = cv4.imdecode(page.bytes, cv4.IMREAD_UNCHANGED);
    final channels = decoded.channels;
    decoded.dispose();
    expect(channels, 4);
  });

  test('applies a conservative white balance correction to a color-cast '
      'bright background, producing different (re-encoded) bytes', () async {
    // Slightly blue-deficient "white" background (B lower than G/R), but
    // still within the default "sufficiently neutral" spread so it
    // qualifies as a white-balance sample.
    const originalB = 205;
    const originalR = 216;
    final pixels = _solidColorBgr(220, 220, originalB, 213, originalR);
    final file = await _writeJpeg(tempDir, 'page.jpg', pixels, 220, 220);
    final originalBytes = await file.readAsBytes();

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    expect(pages.single.pixelWidth, 220);
    expect(pages.single.pixelHeight, 220);
    // A correction was applied, so the bytes must have been re-encoded
    // (they will differ from the untouched original file bytes).
    expect(pages.single.bytes, isNot(equals(originalBytes)));
    expect(pages.single.sourceBytesReused, isFalse);
    // The PDF page preparation pipeline always starts its adaptive JPEG
    // ladder at the highest quality; a small, easily-compressed solid-color
    // page like this one is accepted on the very first attempt.
    expect(pages.single.selectedJpegQuality, kPdfPageJpegQualityFirst);
    expect(pages.single.encodeAttempts, 1);

    // The corrected image should be closer to neutral than the original.
    final correctedMat = cv4.imdecode(pages.single.bytes, cv4.IMREAD_COLOR);
    final data = correctedMat.data;
    correctedMat.dispose();
    final b = data[0];
    final r = data[2];
    expect((b - r).abs(), lessThan((originalB - originalR).abs()));
  });

  test('splits a very long narrow color page into multiple ordered PDF pages, '
      'each within the pixel budget', () async {
    const width = 800;
    const height = 20000; // extreme aspect ratio, well over budget.
    final pixels = _solidColorBgr(width, height, 90, 110, 130);
    final file = await _writeJpeg(
      tempDir,
      'long_page.jpg',
      pixels,
      width,
      height,
    );

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages.length, greaterThan(1));
    for (final page in pages) {
      expect(page.pixelWidth, width);
      expect(
        page.pixelWidth * page.pixelHeight,
        lessThanOrEqualTo(kMaxPdfPagePixelBudget),
      );
    }
    // Ordered coverage: heights sum (minus overlap) should reconstruct
    // the full original long edge, and the last segment must reach the
    // full original height.
    final totalCoveredWithOverlap = pages.fold<int>(
      0,
      (sum, page) => sum + page.pixelHeight,
    );
    expect(totalCoveredWithOverlap, greaterThanOrEqualTo(height));
  });

  test('never upscales a small page, and reuses its bytes verbatim (no '
      'JPEG encode at all)', () async {
    final pixels = _solidColorBgr(64, 48, 90, 110, 130);
    final file = await _writeJpeg(tempDir, 'tiny.jpg', pixels, 64, 48);
    final originalBytes = await file.readAsBytes();

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    expect(pages.single.pixelWidth, 64);
    expect(pages.single.pixelHeight, 48);
    expect(pages.single.bytes, equals(originalBytes));
    expect(pages.single.sourceBytesReused, isTrue);
    expect(pages.single.encodeAttempts, 0);
  });

  test('a long receipt at exactly the documented 1600px short-edge '
      'preservation threshold keeps its native short-edge resolution '
      'exactly (no shrink at all) across every segment, even under a '
      'noisy/textured fixture that forces every applicable adaptive-JPEG '
      'ladder attempt', () async {
    const shortEdge = 1600;
    const longEdge = 6000; // extreme aspect ratio, over the 5.0MP budget.
    final pixels = _noisyTexturedReceiptBgr(shortEdge, longEdge);
    final file = await _writeJpeg(
      tempDir,
      'receipt.jpg',
      pixels,
      shortEdge,
      longEdge,
    );

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages.length, greaterThan(1));
    for (final page in pages) {
      // The native short edge sits exactly at the documented 1600px
      // preservation threshold, so it must be preserved *exactly* — never
      // shrunk toward the 1400px fallback floor — even though each
      // segment's own pixel count exceeds the 3.5MP fallback budget.
      expect(page.pixelWidth, shortEdge);
      // High-entropy content never compresses under the soft target, so
      // every applicable ladder attempt is exhausted. Since the native
      // short edge is preserved exactly, no genuine fallback downscale is
      // possible, so only 3 (not 4) attempts are ever applicable.
      expect(page.encodeAttempts, 3);
      expect(page.selectedJpegQuality, kPdfPageJpegQualityFinal);
    }
  });

  test('a realistic photographed document prepares a JPEG within the '
      '550 KiB soft target', () async {
    const width = 2200;
    const height = 1700;
    final file = await _writeJpeg(
      tempDir,
      'photographed_document.jpg',
      _realisticPhotographedDocumentBgr(width, height),
      width,
      height,
    );

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    expect(pages.single.bytes.lengthInBytes, lessThanOrEqualTo(550 * 1024));
    expect(pages.single.bytes[0], 0xFF);
    expect(pages.single.bytes[1], 0xD8);
  });

  test('a two-page PDF from realistic photographed documents stays below '
      'the stable 1.2 MiB ceiling', () async {
    const width = 2200;
    const height = 1700;
    final first = await _writeJpeg(
      tempDir,
      'photographed_document_a.jpg',
      _realisticPhotographedDocumentBgr(width, height, seed: 11),
      width,
      height,
    );
    final second = await _writeJpeg(
      tempDir,
      'photographed_document_b.jpg',
      _realisticPhotographedDocumentBgr(width, height, seed: 29),
      width,
      height,
    );

    final pdf = await assembleDocumentPdfBytes([first.path, second.path]);

    expect(pdf.lengthInBytes, lessThan(1.2 * 1024 * 1024));
  });

  test('a deterministic high-entropy color page over the pixel budget uses '
      'the full adaptive ladder (at most 4 attempts) and never drops below '
      'the documented quality floor', () async {
    // Chosen to exceed the 5.0MP main budget (forcing an initial
    // pixel-budget resize) so this exercises the full
    // preparePdfPagesForFile -> encodePdfPageJpegAdaptive path end to end.
    const width = 3000;
    const height = 2000;
    final pixels = Uint8List(width * height * 3);
    final random = Random(99);
    for (var i = 0; i < pixels.length; i++) {
      pixels[i] = random.nextInt(256);
    }
    final file = await _writeJpeg(
      tempDir,
      'high_entropy.jpg',
      pixels,
      width,
      height,
    );

    final pages = await preparePdfPagesForFile(file.path);

    expect(pages, hasLength(1));
    final page = pages.single;
    expect(page.sourceBytesReused, isFalse);
    expect(page.encodeAttempts, lessThanOrEqualTo(4));
    expect(
      page.selectedJpegQuality,
      greaterThanOrEqualTo(kPdfPageJpegQualityFinal),
    );
    // Never upscaled beyond the pixel-budget-resized raster.
    expect(
      page.pixelWidth * page.pixelHeight,
      lessThanOrEqualTo(kMaxPdfPagePixelBudget * (1 + 1e-6)),
    );
  });

  test(
    'assembleDocumentPdfBytes produces a non-empty PDF for a single page',
    () async {
      final pixels = _solidColorBgr(300, 200, 90, 110, 130);
      final file = await _writeJpeg(tempDir, 'page.jpg', pixels, 300, 200);

      final bytes = await assembleDocumentPdfBytes([file.path]);

      expect(bytes, isNotEmpty);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    },
  );

  test('assembleDocumentPdfBytes rejects an empty file path list with an '
      'ArgumentError', () async {
    expect(
      () => assembleDocumentPdfBytes(const []),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('assembleAndWriteDocumentPdfToFile writes the assembled PDF directly '
      'to the given output path and reports its byte length and page '
      'count without returning the PDF bytes themselves', () async {
    final pixelsA = _solidColorBgr(300, 200, 90, 110, 130);
    final fileA = await _writeJpeg(tempDir, 'page_a.jpg', pixelsA, 300, 200);
    final pixelsB = _solidColorBgr(300, 200, 10, 20, 30);
    final fileB = await _writeJpeg(tempDir, 'page_b.jpg', pixelsB, 300, 200);
    final outputPath = p.join(tempDir.path, 'output.pdf');

    final result = await assembleAndWriteDocumentPdfToFile((
      filePaths: [fileA.path, fileB.path],
      outputPath: outputPath,
    ));

    expect(result.pageCount, 2);
    final outputFile = File(outputPath);
    expect(await outputFile.exists(), isTrue);
    final writtenBytes = await outputFile.readAsBytes();
    expect(writtenBytes.lengthInBytes, result.byteLength);
    expect(String.fromCharCodes(writtenBytes.take(5)), '%PDF-');

    // Matches assembleDocumentPdfBytes's output for the same input.
    final expectedBytes = await assembleDocumentPdfBytes([
      fileA.path,
      fileB.path,
    ]);
    expect(writtenBytes.lengthInBytes, expectedBytes.lengthInBytes);
  });

  test('assembleAndWriteDocumentPdfToFile rejects an empty file path list '
      'with an ArgumentError and does not create the output file', () async {
    final outputPath = p.join(tempDir.path, 'output.pdf');

    await expectLater(
      assembleAndWriteDocumentPdfToFile((
        filePaths: const [],
        outputPath: outputPath,
      )),
      throwsA(isA<ArgumentError>()),
    );
    expect(await File(outputPath).exists(), isFalse);
  });

  test(
    'preparePdfPagesForFile rejects a file that does not contain a decodable '
    'image with a FormatException naming the file path',
    () async {
      final file = File(p.join(tempDir.path, 'not_an_image.jpg'));
      await file.writeAsBytes(Uint8List.fromList([1, 2, 3, 4, 5]));

      await expectLater(
        preparePdfPagesForFile(file.path),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains(file.path),
          ),
        ),
      );
    },
  );
}
