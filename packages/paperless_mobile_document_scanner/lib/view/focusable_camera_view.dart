import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FocusableCameraView extends StatefulWidget {
  final CameraDescription camera;
  final ResolutionPreset resolutionPreset;
  final void Function(CameraController controller, int width, int height)
  onCameraReady;
  const FocusableCameraView({
    super.key,
    required this.camera,
    this.resolutionPreset = ResolutionPreset.medium,
    required this.onCameraReady,
  });

  @override
  State<FocusableCameraView> createState() => _FocusableCameraViewState();
}

class _FocusableCameraViewState extends State<FocusableCameraView>
    with WidgetsBindingObserver {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final cameraController = CameraController(
      widget.camera,
      widget.resolutionPreset,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller = cameraController;
    _initializeCameraController(cameraController);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.stopImageStream();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      if (cameraController.value.isStreamingImages) {
        cameraController.stopImageStream();
      }
      cameraController.dispose();
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      final newController = CameraController(
        widget.camera,
        widget.resolutionPreset,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );
      _controller = newController;
      _initializeCameraController(newController);
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: cameraController.value.previewSize!.height,
          height: cameraController.value.previewSize!.width,
          child: CameraPreview(
            cameraController,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (TapDownDetails details) =>
                      onViewFinderTap(details, constraints),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _initializeCameraController(
    CameraController cameraController,
  ) async {
    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        debugPrint('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      cameraController.setFlashMode(FlashMode.off);
      widget.onCameraReady(
        cameraController,
        cameraController.value.previewSize!.width.toInt(),
        cameraController.value.previewSize!.height.toInt(),
      );
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          debugPrint('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          // iOS only
          debugPrint('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          // iOS only
          debugPrint('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          debugPrint('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          // iOS only
          debugPrint('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          // iOS only
          debugPrint('Audio access is restricted.');
          break;
        default:
          debugPrint('Unknown camera error: ${e.code}');
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }
}
