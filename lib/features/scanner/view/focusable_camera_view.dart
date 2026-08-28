import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FocusableCameraView extends StatefulWidget {
  final CameraDescription camera;
  final ResolutionPreset resolutionPreset;
  final ValueChanged<CameraController> onControllerInitialized;
  final VoidCallback? onControllerInitializationFailed;
  const FocusableCameraView({
    super.key,
    required this.camera,
    this.resolutionPreset = ResolutionPreset.medium,
    required this.onControllerInitialized,
    this.onControllerInitializationFailed,
  });

  @override
  State<FocusableCameraView> createState() => _FocusableCameraViewState();
}

const _focusIndicatorSize = 72.0;

class _FocusableCameraViewState extends State<FocusableCameraView>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  CameraController? _controller;
  Future<void> _controllerTransition = Future.value();
  int _controllerGeneration = 0;
  bool _isInactive = false;

  late final AnimationController _focusAnimController;
  Offset? _focusPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusAnimController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 400),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() => _focusPosition = null);
          }
        });
    _scheduleControllerInitialization();
  }

  @override
  void didUpdateWidget(covariant FocusableCameraView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.camera != widget.camera ||
        oldWidget.resolutionPreset != widget.resolutionPreset) {
      _scheduleControllerInitialization();
    }
  }

  @override
  void dispose() {
    _isInactive = true;
    _controllerGeneration++;
    _focusAnimController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _enqueueControllerTransition(_disposeCameraController);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _isInactive = true;
      _scheduleControllerDisposal();
    } else if (state == AppLifecycleState.resumed) {
      _isInactive = false;
      _scheduleControllerInitialization();
    }
  }

  @override
  Widget build(BuildContext context) {
    final CameraController? cameraController = _controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        SizedBox.expand(
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
        ),
        if (_focusPosition != null)
          AnimatedBuilder(
            animation: _focusAnimController,
            builder: (context, child) {
              final t = _focusAnimController.value;
              // Scale: 1.5 → 1.0 over first 30%.
              final scaleT = (t / 0.3).clamp(0.0, 1.0);
              final scale = 1.5 - 0.5 * Curves.easeOut.transform(scaleT);
              // Opacity: 1.0 for first 70%, then fade to 0.
              final opacityT = ((t - 0.7) / 0.3).clamp(0.0, 1.0);
              final opacity = 1.0 - Curves.easeIn.transform(opacityT);
              return Positioned(
                left: _focusPosition!.dx - _focusIndicatorSize / 2,
                top: _focusPosition!.dy - _focusIndicatorSize / 2,
                child: IgnorePointer(
                  child: Opacity(
                    opacity: opacity,
                    child: Transform.scale(scale: scale, child: child),
                  ),
                ),
              );
            },
            child: SizedBox(
              width: _focusIndicatorSize,
              height: _focusIndicatorSize,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _scheduleControllerInitialization() {
    final generation = ++_controllerGeneration;
    _enqueueControllerTransition(() => _replaceCameraController(generation));
  }

  void _scheduleControllerDisposal() {
    _controllerGeneration++;
    _enqueueControllerTransition(_disposeCameraController);
  }

  void _enqueueControllerTransition(Future<void> Function() operation) {
    _controllerTransition = _controllerTransition.then((_) async {
      try {
        await operation();
      } catch (error, stackTrace) {
        debugPrint('Camera controller transition failed: $error');
        debugPrintStack(stackTrace: stackTrace);
      }
    });
    unawaited(_controllerTransition);
  }

  Future<void> _replaceCameraController(int generation) async {
    await _disposeCameraController();
    if (!mounted || _isInactive || generation != _controllerGeneration) return;

    final cameraController = CameraController(
      widget.camera,
      widget.resolutionPreset,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller = cameraController;
    setState(() {});

    cameraController.addListener(() {
      if (mounted && identical(cameraController, _controller)) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        debugPrint('Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      if (!_isCurrentController(cameraController, generation)) {
        await _disposeStaleController(cameraController);
        return;
      }
      await cameraController.setFlashMode(FlashMode.off);
      if (!_isCurrentController(cameraController, generation)) {
        await _disposeStaleController(cameraController);
        return;
      }
      widget.onControllerInitialized(cameraController);
    } on CameraException catch (error) {
      _logCameraException(error);
      final shouldReportFailure =
          mounted && generation == _controllerGeneration;
      if (identical(_controller, cameraController)) {
        _controller = null;
      }
      await cameraController.dispose();
      if (shouldReportFailure &&
          mounted &&
          generation == _controllerGeneration) {
        widget.onControllerInitializationFailed?.call();
      }
    }

    if (mounted && generation == _controllerGeneration) {
      setState(() {});
    }
  }

  bool _isCurrentController(CameraController controller, int generation) {
    return mounted &&
        !_isInactive &&
        generation == _controllerGeneration &&
        identical(controller, _controller);
  }

  Future<void> _disposeStaleController(CameraController controller) async {
    if (identical(_controller, controller)) {
      _controller = null;
    }
    await controller.dispose();
  }

  Future<void> _disposeCameraController() async {
    final controller = _controller;
    _controller = null;
    if (controller == null) return;

    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
    } on CameraException catch (error) {
      debugPrint('Could not stop camera image stream: $error');
    }

    await controller.dispose();
    if (mounted) {
      setState(() {});
    }
  }

  void _logCameraException(CameraException error) {
    switch (error.code) {
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
        debugPrint('Unknown camera error: ${error.code}');
        break;
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

    // Show focus indicator at the tap position in screen coordinates.
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      setState(() {
        _focusPosition = box.globalToLocal(details.globalPosition);
      });
      _focusAnimController.forward(from: 0.0);
    }
  }
}
