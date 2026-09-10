import 'dart:typed_data';

/// Crops a rectangular region out of a flat, interleaved, row-major pixel
/// buffer with no inter-row padding (i.e. `pixels.length == srcWidth *
/// srcHeight * channels`).
///
/// [left]/[top]/[width]/[height] are integer pixel coordinates and are
/// clamped to the source bounds, so callers may pass rounded
/// floating-point-derived rectangles without first worrying about exact
/// edge cases. Returns the cropped buffer together with its resolved
/// (post-clamp) pixel dimensions.
///
/// This is a pure, native-dependency-free building block used by the PDF
/// page segmentation pipeline to cut a decoded page into ordered segments.
class CroppedPixels {
  final Uint8List pixels;
  final int width;
  final int height;

  const CroppedPixels({
    required this.pixels,
    required this.width,
    required this.height,
  });
}

CroppedPixels cropInterleavedPixels(
  Uint8List pixels, {
  required int srcWidth,
  required int srcHeight,
  required int channels,
  required int left,
  required int top,
  required int width,
  required int height,
}) {
  assert(
    pixels.length == srcWidth * srcHeight * channels,
    'pixel buffer length must exactly match srcWidth*srcHeight*channels',
  );

  final clampedLeft = left.clamp(0, srcWidth);
  final clampedTop = top.clamp(0, srcHeight);
  final right = (left + width).clamp(clampedLeft, srcWidth);
  final bottom = (top + height).clamp(clampedTop, srcHeight);
  final outWidth = right - clampedLeft;
  final outHeight = bottom - clampedTop;

  final rowBytes = outWidth * channels;
  final output = Uint8List(rowBytes * outHeight);
  for (var y = 0; y < outHeight; y++) {
    final srcRowStart = ((clampedTop + y) * srcWidth + clampedLeft) * channels;
    final dstRowStart = y * rowBytes;
    output.setRange(dstRowStart, dstRowStart + rowBytes, pixels, srcRowStart);
  }

  return CroppedPixels(pixels: output, width: outWidth, height: outHeight);
}
