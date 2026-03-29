import 'package:flutter/painting.dart';

class DocumentFrame {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;

  DocumentFrame({
    required this.topLeft,
    required this.topRight,
    required this.bottomRight,
    required this.bottomLeft,
  });

  DocumentFrame scale(double scaleX, double scaleY) {
    return DocumentFrame(
      topLeft: Offset(topLeft.dx * scaleX, topLeft.dy * scaleY),
      topRight: Offset(topRight.dx * scaleX, topRight.dy * scaleY),
      bottomRight: Offset(bottomRight.dx * scaleX, bottomRight.dy * scaleY),
      bottomLeft: Offset(bottomLeft.dx * scaleX, bottomLeft.dy * scaleY),
    );
  }

  /// Linearly interpolates between this frame and [other] by [t].
  /// At t=0 returns this, at t=1 returns [other].
  DocumentFrame lerpTo(DocumentFrame other, double t) {
    return DocumentFrame(
      topLeft: Offset.lerp(topLeft, other.topLeft, t)!,
      topRight: Offset.lerp(topRight, other.topRight, t)!,
      bottomRight: Offset.lerp(bottomRight, other.bottomRight, t)!,
      bottomLeft: Offset.lerp(bottomLeft, other.bottomLeft, t)!,
    );
  }

  @override
  String toString() {
    return 'DocumentFrame(topLeft: $topLeft, topRight: $topRight, bottomRight: $bottomRight, bottomLeft: $bottomLeft)';
  }
}
