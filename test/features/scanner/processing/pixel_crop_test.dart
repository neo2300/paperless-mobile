import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/scanner/processing/pixel_crop.dart';

/// Builds a single-channel buffer where each pixel's value encodes its
/// `(x, y)` position as `y * width + x` (mod 256), so cropped regions can
/// be verified pixel-by-pixel against the expected source coordinates.
Uint8List _buildIndexedImage(int width, int height) {
  final pixels = Uint8List(width * height);
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      pixels[y * width + x] = (y * width + x) % 256;
    }
  }
  return pixels;
}

void main() {
  test('crops an interior rectangle preserving pixel values and order', () {
    const width = 10;
    const height = 8;
    final source = _buildIndexedImage(width, height);

    final result = cropInterleavedPixels(
      source,
      srcWidth: width,
      srcHeight: height,
      channels: 1,
      left: 2,
      top: 1,
      width: 4,
      height: 3,
    );

    expect(result.width, 4);
    expect(result.height, 3);
    for (var y = 0; y < result.height; y++) {
      for (var x = 0; x < result.width; x++) {
        final expected = ((1 + y) * width + (2 + x)) % 256;
        expect(result.pixels[y * result.width + x], expected);
      }
    }
  });

  test('clamps a rectangle that extends past the source bounds', () {
    const width = 5;
    const height = 5;
    final source = _buildIndexedImage(width, height);

    final result = cropInterleavedPixels(
      source,
      srcWidth: width,
      srcHeight: height,
      channels: 1,
      left: 3,
      top: 3,
      width: 10,
      height: 10,
    );

    // Only the bottom-right 2x2 region remains within bounds.
    expect(result.width, 2);
    expect(result.height, 2);
    expect(result.pixels[0], (3 * width + 3) % 256);
  });

  test('clamps a negative origin to the source bounds', () {
    const width = 6;
    const height = 6;
    final source = _buildIndexedImage(width, height);

    final result = cropInterleavedPixels(
      source,
      srcWidth: width,
      srcHeight: height,
      channels: 1,
      left: -2,
      top: -2,
      width: 4,
      height: 4,
    );

    expect(result.width, 2);
    expect(result.height, 2);
    expect(result.pixels[0], 0); // top-left source pixel.
  });

  test('preserves multi-channel interleaving when cropping', () {
    const width = 3;
    const height = 2;
    const channels = 3;
    // Pixel (x, y) = [r, g, b] = [x, y, x + y].
    final source = Uint8List(width * height * channels);
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final base = (y * width + x) * channels;
        source[base] = x;
        source[base + 1] = y;
        source[base + 2] = x + y;
      }
    }

    final result = cropInterleavedPixels(
      source,
      srcWidth: width,
      srcHeight: height,
      channels: channels,
      left: 1,
      top: 0,
      width: 2,
      height: 2,
    );

    expect(result.width, 2);
    expect(result.height, 2);
    // (x=1, y=0)
    expect(result.pixels.sublist(0, 3), [1, 0, 1]);
    // (x=2, y=0)
    expect(result.pixels.sublist(3, 6), [2, 0, 2]);
    // (x=1, y=1)
    expect(result.pixels.sublist(6, 9), [1, 1, 2]);
    // (x=2, y=1)
    expect(result.pixels.sublist(9, 12), [2, 1, 3]);
  });

  test('returns an empty crop for a fully out-of-bounds rectangle', () {
    const width = 4;
    const height = 4;
    final source = _buildIndexedImage(width, height);

    final result = cropInterleavedPixels(
      source,
      srcWidth: width,
      srcHeight: height,
      channels: 1,
      left: 20,
      top: 20,
      width: 5,
      height: 5,
    );

    expect(result.width, 0);
    expect(result.height, 0);
    expect(result.pixels, isEmpty);
  });
}
