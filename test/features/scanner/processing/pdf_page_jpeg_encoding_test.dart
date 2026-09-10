// Pure planning tests for the adaptive PDF-page JPEG encode ladder. These
// exercise only [planPdfPageJpegEncodeAttempts] and
// [planPdfPageFallbackDownscale] — no native/OpenCV dependency — so they
// always run, even without a `cmake` toolchain on PATH. See
// `document_pdf_builder_test.dart` for the corresponding native, actually-
// encoded-bytes integration tests.
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/scanner/processing/pdf_page_jpeg_encoding.dart';

void main() {
  group('planPdfPageFallbackDownscale', () {
    test('leaves a raster already within the fallback budget unchanged '
        '(no upscale, no-op)', () {
      const size = Size(1000, 800); // 0.8MP, well under 3.5MP.
      final result = planPdfPageFallbackDownscale(
        currentSize: size,
        nativeShortEdgePixels: 800,
      );
      expect(result, size);
    });

    test('downscales an over-budget raster proportionally, never below the '
        'native-short-edge floor', () {
      const size = Size(4000, 2000); // 8MP, over the 3.5MP fallback budget.
      final result = planPdfPageFallbackDownscale(
        currentSize: size,
        nativeShortEdgePixels: 2000,
      );
      // Downscaled, not upscaled.
      expect(result.width, lessThan(size.width));
      expect(result.height, lessThan(size.height));
      // Aspect ratio preserved.
      expect(
        result.width / result.height,
        closeTo(size.width / size.height, 1e-9),
      );
      // Downscaled toward (though, once the floor clamps it, not
      // necessarily all the way under) the fallback budget.
      expect(result.width * result.height, lessThan(size.width * size.height));
      // Never below the short-edge floor cap.
      expect(
        result.height,
        greaterThanOrEqualTo(kPdfPageJpegShortEdgeFloorCap),
      );
    });

    test('preserves an at-threshold native short edge even for an extremely '
        'oversized raster', () {
      const size = Size(10000, 1500); // short edge 1500, over budget.
      final result = planPdfPageFallbackDownscale(
        currentSize: size,
        nativeShortEdgePixels: 1500,
        shortEdgeFloorCap: 1400,
      );
      expect(result.height, 1500);
    });

    test('is a no-op when the short edge is already at (or under) the '
        'floor, even though the raster is still "over budget"', () {
      const size = Size(20000, 1200); // short edge already below the 1400 cap.
      final result = planPdfPageFallbackDownscale(
        currentSize: size,
        nativeShortEdgePixels: 1200,
        shortEdgeFloorCap: 1400,
      );
      expect(result, size);
    });

    test('respects a native short edge smaller than the floor cap (never '
        'upscales toward the cap)', () {
      const size = Size(3000, 1000); // native short edge 1000 < cap 1400.
      final result = planPdfPageFallbackDownscale(
        currentSize: size,
        nativeShortEdgePixels: 1000,
        shortEdgeFloorCap: 1400,
        fallbackPixelBudget: 1e6, // force an attempted downscale.
      );
      // At or below 1600 the native short edge itself is the floor, so this
      // must be a no-op, never an upscale past 1000.
      expect(result.height, 1000);
    });

    group('native short-edge preservation threshold boundary (1600px)', () {
      test('preserves the native short edge exactly at 1599px (just under '
          'the threshold), never shrinking it toward the 1400px floor', () {
        const size = Size(1599, 4000); // over the fallback budget on its own.
        final result = planPdfPageFallbackDownscale(
          currentSize: size,
          nativeShortEdgePixels: 1599,
        );
        expect(result.width, 1599);
      });

      test('preserves the native short edge exactly at 1600px (right at '
          'the threshold), never shrinking it toward the 1400px floor', () {
        const size = Size(1600, 4000);
        final result = planPdfPageFallbackDownscale(
          currentSize: size,
          nativeShortEdgePixels: 1600,
        );
        expect(result.width, 1600);
      });

      test('allows shrinking toward the 1400px floor once the native '
          'short edge exceeds the 1600px threshold (1601px)', () {
        const size = Size(1601, 4000);
        final result = planPdfPageFallbackDownscale(
          currentSize: size,
          nativeShortEdgePixels: 1601,
        );
        expect(result.width, lessThan(1601));
        expect(result.width, greaterThanOrEqualTo(1400));
      });
    });
  });

  group('planPdfPageJpegEncodeAttempts', () {
    test('plans exactly three unique attempts (no duplicate) when the '
        'fallback downscale would not genuinely change the raster size', () {
      const raster = Size(2000, 1500); // 3.0MP, within the 3.5MP budget.
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 1500,
      );

      expect(attempts, hasLength(3));
      expect(attempts.map((a) => a.quality), [
        kPdfPageJpegQualityFirst,
        kPdfPageJpegQualitySecond,
        kPdfPageJpegQualityFinal,
      ]);
      expect(attempts.map((a) => a.attemptNumber), [1, 2, 3]);
      expect(attempts.every((a) => a.targetSize == raster), isTrue);
      expect(attempts.every((a) => a.isDownscaled == false), isTrue);
      // Never goes below the documented quality floor.
      expect(
        attempts.every((a) => a.quality >= kPdfPageJpegQualityFinal),
        isTrue,
      );
    });

    test('uses the same floored min-1 dimensions for comparison and plans, '
        'so a fractional fallback cannot add a duplicate resize', () {
      const raster = Size(2000.9, 1500.9);
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 1500,
        // Produces a floating-point fallback smaller than raster but still
        // flooring to exactly 2000x1500.
        fallbackPixelBudget: 3003599,
      );

      expect(attempts, hasLength(3));
      expect(attempts.map((attempt) => attempt.attemptNumber), [1, 2, 3]);
      expect(attempts.map((attempt) => attempt.quality), [84, 74, 64]);
      expect(
        attempts.map((attempt) => attempt.targetSize),
        everyElement(const Size(2000, 1500)),
      );
    });

    test('plans exactly four attempts, with a genuine fallback downscale, '
        'when the raster exceeds the fallback budget past the '
        'native-short-edge floor', () {
      const raster = Size(2400, 2000); // 4.8MP, over the 3.5MP budget.
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 2000, // > 1600px preservation threshold.
      );

      expect(attempts, hasLength(4));
      expect(attempts.map((a) => a.quality), [
        kPdfPageJpegQualityFirst,
        kPdfPageJpegQualitySecond,
        kPdfPageJpegQualitySecond,
        kPdfPageJpegQualityFinal,
      ]);
      expect(attempts.map((a) => a.attemptNumber), [1, 2, 3, 4]);
      expect(attempts[2].targetSize, isNot(raster));
      expect(attempts[3].targetSize, attempts[2].targetSize);
      expect(attempts[2].isDownscaled, isTrue);
      expect(attempts[3].isDownscaled, isTrue);
    });

    test('keeps the first two attempts at the original (planned) raster '
        'size — never upscaled, never pre-emptively downscaled', () {
      const raster = Size(2200, 1600);
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 1600,
      );
      expect(attempts[0].targetSize, raster);
      expect(attempts[1].targetSize, raster);
      expect(attempts[0].isDownscaled, isFalse);
      expect(attempts[1].isDownscaled, isFalse);
    });

    test('downscales the 3rd/4th attempts toward the fallback budget when '
        'the raster exceeds it', () {
      const raster = Size(2400, 2000); // 4.8MP, over the 3.5MP fallback budget.
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 2000,
      );
      expect(attempts[2].targetSize, isNot(raster));
      expect(attempts[3].targetSize, attempts[2].targetSize);
      expect(attempts[2].isDownscaled, isTrue);
      expect(attempts[3].isDownscaled, isTrue);
      // Never upscaled.
      expect(attempts[2].targetSize.width, lessThan(raster.width));
      expect(attempts[2].targetSize.height, lessThan(raster.height));
    });

    test('does not further downscale (and plans only 3 attempts) when the '
        'raster already fits the fallback budget', () {
      const raster = Size(1800, 1400); // 2.52MP, under the 3.5MP budget.
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 1400,
      );
      expect(attempts, hasLength(3));
      expect(attempts[2].targetSize, raster);
      expect(attempts[2].isDownscaled, isFalse);
      expect(attempts[2].quality, kPdfPageJpegQualityFinal);
    });

    test('preserves a long receipt-like native short edge exactly (no '
        'shrink at all, and only 3 attempts planned) when it sits at the '
        'documented 1600px preservation threshold, even though the raster '
        'exceeds the fallback pixel budget', () {
      // A single very-long segment whose short edge sits exactly at the
      // documented 1600px preservation threshold.
      const raster = Size(
        1600,
        3200,
      ); // 5.12MP, over the 3.5MP fallback budget.
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 1600,
      );
      // At (or under) the preservation threshold, the native short edge is
      // preserved exactly — never shrunk toward the 1400px floor — so no
      // genuine downscale is possible and only 3 attempts are planned.
      expect(attempts, hasLength(3));
      for (final attempt in attempts) {
        expect(attempt.targetSize.width, 1600);
        expect(attempt.isDownscaled, isFalse);
      }
    });

    test('retains the full native short edge through the fallback downscale '
        'when it is already at or under the 1600px threshold and the '
        'fallback budget does not force it past the floor', () {
      const raster = Size(1200, 3600); // short edge already <=1600.
      final attempts = planPdfPageJpegEncodeAttempts(
        rasterSize: raster,
        nativeShortEdgePixels: 1200,
      );
      for (final attempt in attempts) {
        expect(attempt.targetSize.width, 1200);
      }
    });
  });
}
