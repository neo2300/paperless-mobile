// Conservative automatic white balance, applied after the perspective crop
// and before PDF embedding.
//
// This deliberately does **not** implement naive gray-world white balance
// (which averages *all* pixels and is easily skewed by colored document
// content). Instead it samples only pixels that are simultaneously:
//  * bright ([kWhiteBalanceMinBrightness]..[kWhiteBalanceMaxBrightness] on
//    the brightest of the first three channels), and
//  * sufficiently neutral (low spread between the brightest and darkest of
//    the first three channels, see [kWhiteBalanceMaxChannelSpread]),
//
// i.e. pixels that plausibly represent the (near-white) paper background
// rather than printed content. If too few such samples are found, the
// function is a no-op (returns the input unchanged with `applied: false`)
// rather than guessing. When it does apply a correction, per-channel gains
// are tightly clamped ([kWhiteBalanceMinGain]..[kWhiteBalanceMaxGain]) to
// avoid any drastic color shift.
//
// This operates on a flat, interleaved, row-major pixel buffer (no padding
// between rows) so it can be unit-tested without any native/OpenCV
// dependency. Only the first three channels (color) are ever modified — a
// fourth channel (e.g. alpha) is always preserved unchanged, and buffers
// with fewer than three channels (grayscale/B&W) are always left untouched.

import 'dart:math' as math;
import 'dart:typed_data';

/// Minimum brightness (on the max of the first three channels) for a pixel
/// to be considered a white-balance sample candidate.
const int kWhiteBalanceMinBrightness = 195;

/// Maximum brightness for a sample candidate; this excludes fully clipped
/// (blown-out) highlights, which are not reliable color references.
const int kWhiteBalanceMaxBrightness = 250;

/// Maximum allowed spread between the brightest and darkest of the first
/// three channels for a pixel to be considered "sufficiently neutral".
const int kWhiteBalanceMaxChannelSpread = 14;

/// Minimum fraction of all pixels that must qualify as samples before a
/// correction is applied at all.
const double kWhiteBalanceMinSamplePixelFraction = 0.002;

/// Absolute floor for the minimum sample count, so very small images still
/// require a meaningful number of samples rather than a handful of pixels.
const int kWhiteBalanceMinSampleCount = 64;

/// Tight clamp bounds for any single channel gain.
const double kWhiteBalanceMinGain = 0.85;
const double kWhiteBalanceMaxGain = 1.18;

/// Pixel sampling stride used by default. A stride of 1 inspects every
/// pixel; larger strides trade sampling completeness for speed on large
/// images while remaining statistically representative.
const int kWhiteBalanceDefaultSampleStride = 1;

/// Result of [applyConservativeWhiteBalance].
class WhiteBalanceResult {
  /// The (possibly corrected) pixel buffer. Identical to the input buffer
  /// instance when [applied] is `false`.
  final Uint8List pixels;

  /// Whether a correction was actually applied.
  final bool applied;

  /// Per-channel gains for the first three channels, in input channel
  /// order. `[1.0, 1.0, 1.0]` when [applied] is `false`.
  final List<double> gains;

  /// Number of pixels that qualified as bright/neutral samples.
  final int sampleCount;

  const WhiteBalanceResult({
    required this.pixels,
    required this.applied,
    required this.gains,
    required this.sampleCount,
  });
}

/// Applies a conservative automatic white balance to an interleaved,
/// row-major pixel buffer with no inter-row padding (i.e. `pixels.length ==
/// width * height * channels`).
///
/// [channels] must be the true sample count per pixel (e.g. 3 for BGR/RGB,
/// 4 for BGRA/RGBA). Channel *order* is irrelevant to this function — it
/// only ever reasons about "the first three channels" by index, so it is
/// safe to use with either BGR(A) or RGB(A) data as long as the same order
/// is used consistently.
WhiteBalanceResult applyConservativeWhiteBalance(
  Uint8List pixels, {
  required int width,
  required int height,
  required int channels,
  int sampleStride = kWhiteBalanceDefaultSampleStride,
  int minBrightness = kWhiteBalanceMinBrightness,
  int maxBrightness = kWhiteBalanceMaxBrightness,
  int maxChannelSpread = kWhiteBalanceMaxChannelSpread,
  double minGain = kWhiteBalanceMinGain,
  double maxGain = kWhiteBalanceMaxGain,
  int? minSampleCount,
}) {
  const noOpGains = [1.0, 1.0, 1.0];

  if (channels < 3) {
    // Grayscale/B&W: always left unchanged.
    return WhiteBalanceResult(
      pixels: pixels,
      applied: false,
      gains: noOpGains,
      sampleCount: 0,
    );
  }

  assert(
    pixels.length == width * height * channels,
    'pixel buffer length must exactly match width*height*channels '
    '(no row padding)',
  );

  final stride = sampleStride < 1 ? 1 : sampleStride;
  // The confidence threshold must be normalized against the number of
  // pixels the stride loop below actually *visits* — i.e. the sampled
  // (decimated) grid population — rather than the full `width * height`
  // pixel count. Otherwise a large `sampleStride` would silently make the
  // effective required-sample fraction far stricter than intended (and,
  // for small images with a stride that overshoots their dimensions,
  // could even make the required count unreachable).
  final sampledWidth = (width + stride - 1) ~/ stride;
  final sampledHeight = (height + stride - 1) ~/ stride;
  final sampledPopulation = sampledWidth * sampledHeight;
  final requiredSamples =
      minSampleCount ??
      math.max(
        kWhiteBalanceMinSampleCount,
        (sampledPopulation * kWhiteBalanceMinSamplePixelFraction).round(),
      );

  var sumC0 = 0;
  var sumC1 = 0;
  var sumC2 = 0;
  var count = 0;

  for (var y = 0; y < height; y += stride) {
    final rowStart = y * width * channels;
    for (var x = 0; x < width; x += stride) {
      final base = rowStart + x * channels;
      final c0 = pixels[base];
      final c1 = pixels[base + 1];
      final c2 = pixels[base + 2];
      final maxC = math.max(c0, math.max(c1, c2));
      final minC = math.min(c0, math.min(c1, c2));
      if (maxC >= minBrightness &&
          maxC <= maxBrightness &&
          (maxC - minC) <= maxChannelSpread) {
        sumC0 += c0;
        sumC1 += c1;
        sumC2 += c2;
        count++;
      }
    }
  }

  if (count < requiredSamples) {
    // Inadequate confidence: no-op, do not guess.
    return WhiteBalanceResult(
      pixels: pixels,
      applied: false,
      gains: noOpGains,
      sampleCount: count,
    );
  }

  final meanC0 = sumC0 / count;
  final meanC1 = sumC1 / count;
  final meanC2 = sumC2 / count;
  final grayTarget = (meanC0 + meanC1 + meanC2) / 3;

  double gainFor(double mean) {
    if (mean <= 1e-6) return 1.0;
    return (grayTarget / mean).clamp(minGain, maxGain);
  }

  final gains = [gainFor(meanC0), gainFor(meanC1), gainFor(meanC2)];

  final output = Uint8List(pixels.length);
  for (var i = 0; i < pixels.length; i += channels) {
    for (var c = 0; c < channels; c++) {
      if (c < 3) {
        final corrected = (pixels[i + c] * gains[c]).round().clamp(0, 255);
        output[i + c] = corrected;
      } else {
        // Preserve any additional channel (e.g. alpha) unchanged.
        output[i + c] = pixels[i + c];
      }
    }
  }

  return WhiteBalanceResult(
    pixels: output,
    applied: true,
    gains: gains,
    sampleCount: count,
  );
}
