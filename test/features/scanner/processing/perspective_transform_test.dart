import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/scanner/models/document_frame.dart';
import 'package:paperless_mobile/features/scanner/processing/perspective_transform.dart';

void main() {
  test('keeps full-resolution crop dimensions', () {
    final size = calculatePerspectiveOutputSize(
      DocumentFrame(
        topLeft: const Offset(500, 200),
        topRight: const Offset(3500, 200),
        bottomRight: const Offset(3500, 2800),
        bottomLeft: const Offset(500, 2800),
      ),
    );

    expect(size.width, 3000);
    expect(size.height, 2600);
  });

  test('scales preview coordinates to still-image coordinates', () {
    final previewFrame = DocumentFrame(
      topLeft: const Offset(100, 100),
      topRight: const Offset(900, 100),
      bottomRight: const Offset(900, 650),
      bottomLeft: const Offset(100, 650),
    );
    final fullResolution = previewFrame.scale(4, 4);
    final size = calculatePerspectiveOutputSize(fullResolution);

    expect(fullResolution.topLeft, const Offset(400, 400));
    expect(fullResolution.bottomRight, const Offset(3600, 2600));
    expect(size, const Size(3200, 2200));
  });
}
