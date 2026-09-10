import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/scanner/processing/white_balance.dart';

/// Builds a flat, interleaved, row-major BGR(A) buffer for a `width x
/// height` image filled with [background], with an optional centered block
/// of [foreground] pixels representing printed content (so the sample
/// selection logic has something plausible to *not* pick up).
Uint8List _buildImage({
  required int width,
  required int height,
  required List<int> background,
  List<int>? foreground,
  int channels = 3,
}) {
  final pixels = Uint8List(width * height * channels);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final base = (y * width + x) * channels;
      final isForeground =
          foreground != null &&
          x > width ~/ 4 &&
          x < (3 * width) ~/ 4 &&
          y > height ~/ 4 &&
          y < (3 * height) ~/ 4;
      final color = isForeground ? foreground : background;
      for (var c = 0; c < channels; c++) {
        pixels[base + c] = color[c];
      }
    }
  }
  return pixels;
}

void main() {
  group('applyConservativeWhiteBalance — no-op cases', () {
    test('is a no-op for single-channel (grayscale/B&W) buffers', () {
      final pixels = Uint8List.fromList(List.generate(100, (i) => i % 256));
      final result = applyConservativeWhiteBalance(
        pixels,
        width: 10,
        height: 10,
        channels: 1,
      );

      expect(result.applied, isFalse);
      expect(result.pixels, same(pixels));
      expect(result.gains, [1.0, 1.0, 1.0]);
    });

    test('is a no-op when there are not enough bright, neutral samples '
        '(inadequate confidence)', () {
      // A uniformly mid-gray, moderately dark image: nothing qualifies as
      // a bright-enough neutral sample.
      final pixels = _buildImage(
        width: 40,
        height: 40,
        background: [120, 120, 120],
      );
      final result = applyConservativeWhiteBalance(
        pixels,
        width: 40,
        height: 40,
        channels: 3,
      );

      expect(result.applied, isFalse);
      expect(result.pixels, same(pixels));
      expect(result.sampleCount, 0);
    });

    test(
      'leaves an already-neutral bright background essentially unchanged',
      () {
        final pixels = _buildImage(
          width: 60,
          height: 60,
          background: [230, 230, 230],
          foreground: [40, 40, 40],
        );
        final result = applyConservativeWhiteBalance(
          pixels,
          width: 60,
          height: 60,
          channels: 3,
        );

        expect(result.applied, isTrue);
        for (final gain in result.gains) {
          expect(gain, closeTo(1.0, 1e-9));
        }
        // Pixel values effectively unchanged (allowing rounding of ~0 gain).
        expect(result.pixels[0], inInclusiveRange(228, 232));
      },
    );
  });

  group('applyConservativeWhiteBalance — corrects a color cast', () {
    test('corrects a warm (yellowish) cast in the bright background', () {
      // Background looks like slightly-yellow paper: B is noticeably lower
      // than G/R, but still "neutral enough" to qualify as a sample
      // (spread is at the edge of what's allowed).
      final pixels = _buildImage(
        width: 80,
        height: 80,
        background: [200, 214, 220], // B, G, R
        foreground: [30, 30, 30],
      );
      final result = applyConservativeWhiteBalance(
        pixels,
        width: 80,
        height: 80,
        channels: 3,
        maxChannelSpread: 25,
      );

      expect(result.applied, isTrue);
      // Blue (channel 0, the weakest channel) should be boosted; red
      // (channel 2, the strongest) should be reduced or left as-is.
      expect(result.gains[0], greaterThan(1.0));
      expect(result.gains[2], lessThanOrEqualTo(1.0));

      // After correction, the previously-biased background should be much
      // closer to neutral (channels close to each other).
      final b = result.pixels[0];
      final g = result.pixels[1];
      final r = result.pixels[2];
      expect((b - r).abs(), lessThan(20));
      expect((b - g).abs(), lessThan(20));
    });

    test('tightly clamps gains even for an extreme color cast', () {
      // Extremely biased "white" sample — one channel far weaker than the
      // others — should still only be corrected within the tight clamp
      // bounds, never fully "fixed".
      final pixels = _buildImage(
        width: 80,
        height: 80,
        background: [196, 249, 249],
        foreground: [30, 30, 30],
      );
      final result = applyConservativeWhiteBalance(
        pixels,
        width: 80,
        height: 80,
        channels: 3,
        maxChannelSpread: 60,
      );

      expect(result.applied, isTrue);
      for (final gain in result.gains) {
        expect(gain, greaterThanOrEqualTo(kWhiteBalanceMinGain));
        expect(gain, lessThanOrEqualTo(kWhiteBalanceMaxGain));
      }
      // The weak channel's gain should be pinned at the tight upper clamp,
      // not fully correcting the (much larger) theoretical bias.
      expect(result.gains[0], closeTo(kWhiteBalanceMaxGain, 1e-9));
    });

    test('accepts the same qualifying-pixel fraction regardless of sample '
        'stride (confidence is normalized to the sampled population)', () {
      // A background that entirely qualifies as a bright/neutral sample,
      // so the qualifying *fraction* of the (decimated) sampled grid is
      // always 100%, independent of `sampleStride`. The image is large
      // enough, and the strides wide enough, that a required-sample
      // count computed against the *full* `width*height` pixel count
      // (rather than the actually-visited sampled population) would
      // exceed the number of pixels the stride loop can ever visit —
      // i.e. it would wrongly reject every stride above 1.
      const width = 1600;
      const height = 1600;
      final pixels = _buildImage(
        width: width,
        height: height,
        background: [200, 214, 220],
      );

      for (final stride in [1, 4, 16, 32]) {
        final result = applyConservativeWhiteBalance(
          pixels,
          width: width,
          height: height,
          channels: 3,
          sampleStride: stride,
          maxChannelSpread: 25,
        );

        expect(
          result.applied,
          isTrue,
          reason: 'expected acceptance at stride=$stride',
        );
      }
    });

    test('rejects the same (too-low) qualifying-pixel fraction regardless of '
        'sample stride', () {
      // Only a small corner qualifies as bright/neutral; the rest is a
      // mid-gray foreground that never qualifies. The qualifying
      // *fraction* of the sampled grid stays roughly constant across
      // strides, and is deliberately kept under the 0.2% threshold.
      const width = 200;
      const height = 200;
      final pixels = Uint8List(width * height * 3);
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          final base = (y * width + x) * 3;
          final isQualifying = x < 2 && y < 2;
          final color = isQualifying ? [200, 214, 220] : [120, 120, 120];
          pixels[base] = color[0];
          pixels[base + 1] = color[1];
          pixels[base + 2] = color[2];
        }
      }

      for (final stride in [1, 2, 4, 8]) {
        final result = applyConservativeWhiteBalance(
          pixels,
          width: width,
          height: height,
          channels: 3,
          sampleStride: stride,
          maxChannelSpread: 25,
        );

        expect(
          result.applied,
          isFalse,
          reason: 'expected rejection at stride=$stride',
        );
      }
    });

    test('preserves a fourth (alpha) channel unchanged', () {
      const channels = 4;
      final pixels = _buildImage(
        width: 60,
        height: 60,
        background: [200, 214, 220, 77],
        foreground: [30, 30, 30, 255],
        channels: channels,
      );
      final result = applyConservativeWhiteBalance(
        pixels,
        width: 60,
        height: 60,
        channels: channels,
        maxChannelSpread: 25,
      );

      expect(result.applied, isTrue);
      // Alpha (channel index 3) must be preserved exactly, everywhere.
      for (var i = 3; i < result.pixels.length; i += channels) {
        expect(result.pixels[i], pixels[i]);
      }
    });
  });
}
