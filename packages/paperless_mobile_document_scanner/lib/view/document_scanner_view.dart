import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/data/debug_stage.dart';
import 'package:paperless_mobile_document_scanner/data/document_frame.dart';
import 'package:paperless_mobile_document_scanner/processing/detect_edges.dart';
import 'package:paperless_mobile_document_scanner/view/focusable_camera_view.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/frame_overlay_painter.dart';

class DocumentScannerView extends StatefulWidget {
  final CameraDescription camera;
  final DebugStage debugStage;
  final ResolutionPreset resolutionPreset;
  final void Function(CameraController controller, int width, int height)
  onCameraReady;

  /// Called whenever the detected frame or image size changes.
  /// Passes the current smoothed frame (or null) and the image size (or null).
  final void Function(DocumentFrame? frame, Size? imageSize)? onFrameChanged;

  const DocumentScannerView({
    super.key,
    required this.camera,
    this.debugStage = DebugStage.none,
    this.resolutionPreset = ResolutionPreset.medium,
    required this.onCameraReady,
    this.onFrameChanged,
  });

  @override
  State<DocumentScannerView> createState() => _DocumentScannerViewState();
}

class _DocumentScannerViewState extends State<DocumentScannerView> {
  DocumentFrame? _currentFrame;
  Size? _imageSize;
  ui.Image? _debugUiImage;

  /// Smoothing factor for the exponential moving average (0..1).
  /// Lower values produce smoother (but more laggy) corner positions.
  /// 0.3 gives a good balance between responsiveness and stability.
  static const _smoothingFactor = 0.3;

  DocumentFrame? _smoothedFrame;

  @override
  void dispose() {
    _debugUiImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showDebug = widget.debugStage != DebugStage.none;

    return Row(
      children: [
        Expanded(
          flex: showDebug ? 1 : 2,
          child: Stack(
            children: [
              FocusableCameraView(
                camera: widget.camera,
                resolutionPreset: widget.resolutionPreset,
                onCameraReady: onCameraReady,
              ),
              if (_currentFrame != null && _imageSize != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: FrameOverlayPainter(
                      frame: _currentFrame!,
                      imageSize: _imageSize!,
                      frameColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showDebug)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              child: FittedBox(
                fit: BoxFit.contain,
                child: RawImage(image: _debugUiImage),
              ),
            ),
          ),
      ],
    );
  }

  void onCameraReady(CameraController controller, int width, int height) {
    widget.onCameraReady(controller, width, height);
    controller.startImageStream(
      (image) => processImage(
        image,
        widget.camera.sensorOrientation,
        controller.value.deviceOrientation,
        widget.camera.lensDirection,
        _onFrameReceived,
        debugStage: widget.debugStage,
      ),
    );
  }

  void _onFrameReceived(
    DocumentFrame frame,
    Size imageSize,
    ui.Image? debugImage,
  ) async {
    _debugUiImage?.dispose();
    _debugUiImage = debugImage;
    // Apply exponential moving average to smooth corners.
    final smoothed = _smoothedFrame == null
        ? frame
        : _smoothedFrame!.lerpTo(frame, _smoothingFactor);
    _smoothedFrame = smoothed;
    setState(() {
      _currentFrame = smoothed;
      _imageSize = imageSize;
    });
    widget.onFrameChanged?.call(smoothed, imageSize);
  }
}
