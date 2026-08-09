import 'package:camera/camera.dart';

List<CameraDescription> backCameras(Iterable<CameraDescription> cameras) {
  return cameras
      .where((camera) => camera.lensDirection == CameraLensDirection.back)
      .toList(growable: false);
}

CameraDescription selectDefaultCamera(List<CameraDescription> cameras) {
  if (cameras.isEmpty) {
    throw ArgumentError.value(cameras, 'cameras', 'must not be empty');
  }

  final rearCameras = backCameras(cameras);
  for (final camera in rearCameras) {
    if (camera.lensType == CameraLensType.wide) {
      return camera;
    }
  }

  return rearCameras.isNotEmpty ? rearCameras.first : cameras.first;
}

String cameraLabel(CameraDescription camera, int fallbackIndex) {
  return switch (camera.lensType) {
    CameraLensType.wide => '1x / Wide',
    CameraLensType.ultraWide => 'Ultra Wide',
    CameraLensType.telephoto => 'Tele',
    CameraLensType.unknown => 'Camera ${fallbackIndex + 1}',
  };
}
