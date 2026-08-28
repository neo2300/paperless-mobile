import 'dart:typed_data';

import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:paperless_mobile/features/scanner/models/scan_result.dart';
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';

Future<Uint8List> rotateImage(Uint8List imageBytes, int quarterTurns) async {
  final effective = quarterTurns % 4;
  if (effective == 0) return imageBytes;
  final mat = cv4.imdecode(imageBytes, cv4.IMREAD_UNCHANGED);
  final rotated = switch (effective) {
    1 => cv4.rotate(mat, cv4.ROTATE_90_CLOCKWISE),
    2 => cv4.rotate(mat, cv4.ROTATE_180),
    _ => cv4.rotate(mat, cv4.ROTATE_90_COUNTERCLOCKWISE),
  };
  final encoded = encodeDocumentJpeg(rotated);
  mat.dispose();
  rotated.dispose();
  return encoded;
}

Future<Uint8List> toGrayscale(Uint8List imageBytes) async {
  final mat = cv4.imdecode(imageBytes, cv4.IMREAD_COLOR);
  final gray = cv4.cvtColor(mat, cv4.COLOR_BGR2GRAY);
  final encoded = encodeDocumentJpeg(gray);
  mat.dispose();
  gray.dispose();
  return encoded;
}

Future<Uint8List> toBlackAndWhite(
  Uint8List imageBytes, {
  double constant = 10,
}) async {
  final mat = cv4.imdecode(imageBytes, cv4.IMREAD_COLOR);
  final gray = cv4.cvtColor(mat, cv4.COLOR_BGR2GRAY);
  final bw = cv4.adaptiveThreshold(
    gray,
    255,
    cv4.ADAPTIVE_THRESH_GAUSSIAN_C,
    cv4.THRESH_BINARY,
    adaptiveThresholdBlockSize(gray.width, gray.height),
    constant,
  );
  final encoded = encodeDocumentPng(bw);
  mat.dispose();
  gray.dispose();
  bw.dispose();
  return encoded;
}

Future<Uint8List> autoEnhance(Uint8List imageBytes) async {
  final mat = cv4.imdecode(imageBytes, cv4.IMREAD_COLOR);
  final enhanced = await _enhance(mat);
  final encoded = encodeDocumentJpeg(enhanced);
  mat.dispose();
  enhanced.dispose();
  return encoded;
}

/// Applies all selected edits from one decoded crop and encodes only once.
Future<Uint8List> applyDocumentEdits(
  Uint8List croppedBytes, {
  required int quarterTurns,
  required ScanColorFilter colorFilter,
  required double bwThreshold,
  required bool enhanced,
}) async {
  var image = cv4.imdecode(croppedBytes, cv4.IMREAD_COLOR);
  try {
    if (enhanced) {
      final next = await _enhance(image);
      image.dispose();
      image = next;
    }
    switch (quarterTurns % 4) {
      case 1:
        final next = cv4.rotate(image, cv4.ROTATE_90_CLOCKWISE);
        image.dispose();
        image = next;
      case 2:
        final next = cv4.rotate(image, cv4.ROTATE_180);
        image.dispose();
        image = next;
      case 3:
        final next = cv4.rotate(image, cv4.ROTATE_90_COUNTERCLOCKWISE);
        image.dispose();
        image = next;
    }
    if (colorFilter == ScanColorFilter.none) return encodeDocumentJpeg(image);
    final gray = cv4.cvtColor(image, cv4.COLOR_BGR2GRAY);
    image.dispose();
    image = gray;
    if (colorFilter == ScanColorFilter.greyscale) {
      return encodeDocumentJpeg(image);
    }
    final bw = cv4.adaptiveThreshold(
      image,
      255,
      cv4.ADAPTIVE_THRESH_GAUSSIAN_C,
      cv4.THRESH_BINARY,
      adaptiveThresholdBlockSize(image.width, image.height),
      bwThreshold,
    );
    image.dispose();
    image = bw;
    return encodeDocumentPng(image);
  } finally {
    image.dispose();
  }
}

Future<cv4.Mat> _enhance(cv4.Mat image) async {
  final denoised = await cv4.bilateralFilterAsync(image, 5, 40, 40);
  final blurred = await cv4.gaussianBlurAsync(denoised, (0, 0), 1.2);
  final sharpened = await cv4.addWeightedAsync(denoised, 1.7, blurred, -0.7, 0);
  denoised.dispose();
  blurred.dispose();
  return sharpened;
}

int adaptiveThresholdBlockSize(int width, int height) {
  final minDimension = width < height ? width : height;
  var value = (minDimension / 90).round().clamp(21, 81);
  if (value.isEven) value++;
  return value;
}

Future<Uint8List> generateThumbnail(
  Uint8List imageBytes, {
  int maxDimension = 200,
}) async {
  final mat = cv4.imdecode(imageBytes, cv4.IMREAD_COLOR);
  final maxDim = mat.width > mat.height ? mat.width : mat.height;
  if (maxDim <= maxDimension) {
    final encoded = encodeDocumentJpeg(mat);
    mat.dispose();
    return encoded;
  }
  final scale = maxDimension / maxDim;
  final resized = await cv4.resizeAsync(mat, (
    (mat.width * scale).round(),
    (mat.height * scale).round(),
  ));
  final encoded = encodeDocumentJpeg(resized);
  mat.dispose();
  resized.dispose();
  return encoded;
}
