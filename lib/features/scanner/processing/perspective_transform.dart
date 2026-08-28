import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv4;
import 'package:paperless_mobile/features/scanner/models/document_frame.dart';
import 'package:paperless_mobile/features/scanner/processing/document_image_encoding.dart';

/// Applies a perspective (four-point) transform to [imageBytes] so that the
/// quadrilateral defined by [frame] is warped into an axis-aligned rectangle.
///
/// Returns the transformed image as a JPEG without changing crop dimensions.
Future<Uint8List> perspectiveTransform({
  required Uint8List imageBytes,
  required DocumentFrame frame,
}) async {
  // Decode the image using OpenCV.
  final mat = cv4.imdecode(imageBytes, cv4.IMREAD_COLOR);

  final srcPoints = [
    cv4.Point2f(frame.topLeft.dx.toDouble(), frame.topLeft.dy.toDouble()),
    cv4.Point2f(frame.topRight.dx.toDouble(), frame.topRight.dy.toDouble()),
    cv4.Point2f(
      frame.bottomRight.dx.toDouble(),
      frame.bottomRight.dy.toDouble(),
    ),
    cv4.Point2f(frame.bottomLeft.dx.toDouble(), frame.bottomLeft.dy.toDouble()),
  ];

  // Compute the output dimensions from the maximum width/height of the quad.
  final outputSize = calculatePerspectiveOutputSize(frame);
  final maxWidth = outputSize.width;
  final maxHeight = outputSize.height;

  if (kDebugMode) {
    debugPrint(
      'Scan pipeline: perspective source=${mat.width}x${mat.height} '
      'expectedCrop=${maxWidth.round()}x${maxHeight.round()} '
      'frame=$frame',
    );
  }

  final dstPoints = [
    cv4.Point2f(0, 0),
    cv4.Point2f(maxWidth - 1, 0),
    cv4.Point2f(maxWidth - 1, maxHeight - 1),
    cv4.Point2f(0, maxHeight - 1),
  ];

  final srcMat = cv4.VecPoint2f.fromList(srcPoints);
  final dstMat = cv4.VecPoint2f.fromList(dstPoints);

  final transform = cv4.getPerspectiveTransform2f(srcMat, dstMat);

  final warped = await cv4.warpPerspectiveAsync(mat, transform, (
    maxWidth.toInt(),
    maxHeight.toInt(),
  ));

  final encoded = encodeDocumentJpeg(warped);
  if (kDebugMode) {
    debugPrint(
      'Scan pipeline: crop=${warped.width}x${warped.height} '
      'encoding=JPEG quality=$documentJpegQuality '
      'fileSize=${(encoded.length / (1024 * 1024)).toStringAsFixed(2)}MB',
    );
    final captureLongEdge = math.max(mat.width, mat.height);
    final cropLongEdge = math.max(warped.width, warped.height);
    if (captureLongEdge > 2500 &&
        maxWidth * maxHeight > mat.width * mat.height * 0.2 &&
        cropLongEdge < 1000) {
      debugPrint(
        'WARNING: unexpected scanner resolution loss '
        'capture=${mat.width}x${mat.height} crop=${warped.width}x${warped.height} frame=$frame',
      );
    }
  }
  mat.dispose();
  warped.dispose();
  transform.dispose();

  return encoded;
}

double _distance(Offset a, Offset b) {
  final dx = a.dx - b.dx;
  final dy = a.dy - b.dy;
  return math.sqrt(dx * dx + dy * dy);
}

/// Full-resolution output dimensions of a perspective crop. This deliberately
/// uses only the frame coordinates and never preview/display dimensions.
Size calculatePerspectiveOutputSize(DocumentFrame frame) {
  final widthTop = _distance(frame.topLeft, frame.topRight);
  final widthBottom = _distance(frame.bottomLeft, frame.bottomRight);
  final heightLeft = _distance(frame.topLeft, frame.bottomLeft);
  final heightRight = _distance(frame.topRight, frame.bottomRight);
  return Size(
    math.max(widthTop, widthBottom).roundToDouble(),
    math.max(heightLeft, heightRight).roundToDouble(),
  );
}
