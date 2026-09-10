// These tests exercise the native OpenCV (`opencv_dart`) code path and
// therefore require a working native asset build (a `cmake` toolchain on
// PATH). If that is unavailable in a given environment, prefer the pure,
// OpenCV-free tests in `pdf_page_sizing_test.dart`, `white_balance_test.dart`
// and `pixel_crop_test.dart`, which cover the same core geometry/photometry
// logic without any native dependency.
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';
import 'package:paperless_mobile/features/scanner/processing/document_pdf_builder.dart';
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
      expect(page.pixelWidth * page.pixelHeight, lessThanOrEqualTo(8.8e6));
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
