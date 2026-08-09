import 'package:camera/camera.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_mobile/features/scanner/utils/camera_selection.dart';

const _frontCamera = CameraDescription(
  name: 'front',
  lensDirection: CameraLensDirection.front,
  sensorOrientation: 90,
  lensType: CameraLensType.wide,
);
const _unknownBackCamera = CameraDescription(
  name: 'back-unknown',
  lensDirection: CameraLensDirection.back,
  sensorOrientation: 90,
);
const _wideBackCamera = CameraDescription(
  name: 'back-wide',
  lensDirection: CameraLensDirection.back,
  sensorOrientation: 90,
  lensType: CameraLensType.wide,
);
const _ultraWideBackCamera = CameraDescription(
  name: 'back-ultra-wide',
  lensDirection: CameraLensDirection.back,
  sensorOrientation: 90,
  lensType: CameraLensType.ultraWide,
);
const _telephotoBackCamera = CameraDescription(
  name: 'back-telephoto',
  lensDirection: CameraLensDirection.back,
  sensorOrientation: 90,
  lensType: CameraLensType.telephoto,
);

void main() {
  group('selectDefaultCamera', () {
    test('prefers a rear wide camera regardless of camera order', () {
      expect(
        selectDefaultCamera([
          _frontCamera,
          _ultraWideBackCamera,
          _wideBackCamera,
        ]),
        _wideBackCamera,
      );
    });

    test('falls back to the first rear camera without lens metadata', () {
      expect(
        selectDefaultCamera([_frontCamera, _unknownBackCamera]),
        _unknownBackCamera,
      );
    });

    test('falls back to the first available camera without rear cameras', () {
      expect(selectDefaultCamera([_frontCamera]), _frontCamera);
    });

    test('rejects an empty camera list', () {
      expect(() => selectDefaultCamera([]), throwsArgumentError);
    });
  });

  test('backCameras excludes front-facing cameras', () {
    expect(backCameras([_frontCamera, _wideBackCamera, _telephotoBackCamera]), [
      _wideBackCamera,
      _telephotoBackCamera,
    ]);
  });

  test('cameraLabel uses lens types and a stable fallback index', () {
    expect(cameraLabel(_wideBackCamera, 0), '1x / Wide');
    expect(cameraLabel(_ultraWideBackCamera, 1), 'Ultra Wide');
    expect(cameraLabel(_telephotoBackCamera, 2), 'Tele');
    expect(cameraLabel(_unknownBackCamera, 3), 'Camera 4');
  });
}
