// Native (actually-encoded-bytes) integration tests for
// `encodePdfPageJpegAdaptive`. These require a working native asset build
// (a `cmake` toolchain on PATH) — see the pure planning tests in
// `pdf_page_jpeg_encoding_test.dart` for the same core ladder logic
// exercised without any native dependency.
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:paperless_mobile/features/scanner/processing/pdf_page_jpeg_encoding.dart';

/// A "text-like" fixture: a near-white background with a handful of solid
/// black horizontal bands standing in for lines of text. This compresses
/// extremely well, which is the point — it should be accepted by the
/// ladder's very first (highest-quality) attempt.
cv4.Mat _textLikeBgr(int width, int height) {
  final pixels = Uint8List(width * height * 3)
    ..fillRange(0, width * height * 3, 250);
  for (var band = 0; band < 8; band++) {
    final top = (height * (band + 1) / 10).floor();
    for (var y = top; y < top + (height ~/ 60).clamp(1, height); y++) {
      if (y >= height) break;
      final rowStart = y * width * 3;
      for (var x = width ~/ 8; x < width - (width ~/ 8); x++) {
        final i = rowStart + x * 3;
        pixels[i] = 20;
        pixels[i + 1] = 20;
        pixels[i + 2] = 20;
      }
    }
  }
  return cv4.Mat.fromList(height, width, cv4.MatType.CV_8UC3, pixels);
}

/// A deterministic high-entropy fixture (fixed PRNG seed): every pixel is
/// independently random, which JPEG (and PNG) compress poorly — this is
/// what exercises the ladder's full four-attempt path, its quality floor,
/// and its fallback downscale, while still being exactly reproducible
/// across runs/machines.
cv4.Mat _highEntropyBgr(int width, int height, {int seed = 1234}) {
  final random = Random(seed);
  final pixels = Uint8List(width * height * 3);
  for (var i = 0; i < pixels.length; i++) {
    pixels[i] = random.nextInt(256);
  }
  return cv4.Mat.fromList(height, width, cv4.MatType.CV_8UC3, pixels);
}

void main() {
  test('a text-like fixture is accepted by the very first (highest-quality) '
      'attempt, at its original size', () async {
    final mat = _textLikeBgr(900, 700);
    try {
      final result = await encodePdfPageJpegAdaptive(
        mat,
        nativeShortEdgePixels: 700,
      );

      expect(result.attempts, 1);
      expect(result.quality, kPdfPageJpegQualityFirst);
      expect(result.pixelWidth, 900);
      expect(result.pixelHeight, 700);
      expect(
        result.bytes.lengthInBytes,
        lessThanOrEqualTo(kPdfPageJpegSoftTargetBytes),
      );
      // JPEG magic bytes.
      expect(result.bytes[0], 0xFF);
      expect(result.bytes[1], 0xD8);
    } finally {
      mat.dispose();
    }
  });

  test('a deterministic high-entropy fixture exhausts all four attempts, '
      'downscales once, and settles at the quality floor', () async {
    // Chosen so its own pixel count (3.74MP) exceeds the 3.5MP fallback
    // budget (forcing a real downscale at attempts 3/4) while its short
    // edge (1700) comfortably exceeds the 1400px floor.
    final mat = _highEntropyBgr(2200, 1700);
    try {
      final result = await encodePdfPageJpegAdaptive(
        mat,
        nativeShortEdgePixels: 1700,
      );

      // High-entropy content never compresses under the soft target within
      // the bounded ladder, so every attempt must be used.
      expect(result.attempts, 4);
      expect(result.quality, kPdfPageJpegQualityFinal);
      // A real (down-only) fallback downscale happened.
      expect(result.pixelWidth, lessThan(2200));
      expect(result.pixelHeight, lessThan(1700));
      // Never below the short-edge floor.
      expect(result.pixelHeight, greaterThanOrEqualTo(1400));
      // This pathological (high-entropy) page is accepted even though it
      // remains above the advisory ceiling afterwards — OCR's resolution
      // floor wins over file size once the bounded ladder is exhausted.
      expect(
        result.bytes.lengthInBytes,
        greaterThan(kPdfPageJpegAdvisoryCeilingBytes),
      );
    } finally {
      mat.dispose();
    }
  });

  test('encoding the same deterministic high-entropy fixture twice produces '
      'bit-identical output', () async {
    final matA = _highEntropyBgr(1200, 900);
    final matB = _highEntropyBgr(1200, 900);
    try {
      final resultA = await encodePdfPageJpegAdaptive(
        matA,
        nativeShortEdgePixels: 900,
      );
      final resultB = await encodePdfPageJpegAdaptive(
        matB,
        nativeShortEdgePixels: 900,
      );

      expect(resultA.quality, resultB.quality);
      expect(resultA.attempts, resultB.attempts);
      expect(resultA.pixelWidth, resultB.pixelWidth);
      expect(resultA.pixelHeight, resultB.pixelHeight);
      expect(resultA.bytes, equals(resultB.bytes));
    } finally {
      matA.dispose();
      matB.dispose();
    }
  });

  test('never upscales and never shrinks past the native-short-edge floor, '
      'even when every attempt stays above the soft target', () async {
    // A tiny raster whose native short edge is already at or under the
    // 1600px preservation threshold, using a near-zero soft target so
    // every applicable attempt is exhausted.
    final mat = _highEntropyBgr(300, 200);
    try {
      final result = await encodePdfPageJpegAdaptive(
        mat,
        nativeShortEdgePixels: 200,
        softTargetBytes: 1,
        fallbackPixelBudget: 1000,
      );

      // The native short edge (200) is preserved exactly (it is at/under
      // the 1600px preservation threshold), so no genuine fallback
      // downscale is possible: only 3 (not 4) attempts are ever
      // applicable, and dimensions must be completely unchanged, never
      // upscaled.
      expect(result.attempts, 3);
      expect(result.pixelWidth, 300);
      expect(result.pixelHeight, 200);
    } finally {
      mat.dispose();
    }
  });

  test('quality never goes below the documented floor regardless of how '
      'unreachable the soft target is', () async {
    final mat = _highEntropyBgr(500, 400);
    try {
      final result = await encodePdfPageJpegAdaptive(
        mat,
        nativeShortEdgePixels: 400,
        softTargetBytes: 1,
      );
      expect(result.quality, kPdfPageJpegQualityFinal);
      expect(result.quality, greaterThanOrEqualTo(kPdfPageJpegQualityFinal));
    } finally {
      mat.dispose();
    }
  });
}
