import 'dart:typed_data';

import 'package:opencv_dart/opencv_dart.dart' as cv4;

const int documentJpegQuality = 93;

Uint8List encodeDocumentJpeg(cv4.Mat image) {
  final (success, encoded) = cv4.imencode(
    '.jpg',
    image,
    params: [cv4.IMWRITE_JPEG_QUALITY, documentJpegQuality].i32,
  );
  if (!success) throw StateError('Failed to encode document image as JPEG');
  return encoded;
}

Uint8List encodeDocumentPng(cv4.Mat image) {
  final (success, encoded) = cv4.imencode('.png', image);
  if (!success) throw StateError('Failed to encode document image as PNG');
  return encoded;
}
