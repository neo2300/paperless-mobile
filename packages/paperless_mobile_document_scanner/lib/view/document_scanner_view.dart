import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paperless_mobile_document_scanner/models/auto_capture_config.dart';
import 'package:paperless_mobile_document_scanner/models/debug_stage.dart';
import 'package:paperless_mobile_document_scanner/models/document_frame.dart';
import 'package:paperless_mobile_document_scanner/processing/detect_edges.dart';
import 'package:paperless_mobile_document_scanner/processing/edge_detection_isolate.dart';
import 'package:paperless_mobile_document_scanner/processing/frame_stability_tracker.dart';
import 'package:paperless_mobile_document_scanner/view/focusable_camera_view.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/auto_capture_overlay_painter.dart';
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

  /// When `false`, the camera stream is not processed for edge detection and
  /// no frame overlay is shown. Useful on lower-end devices.
  final bool liveEdgeDetectionEnabled;

  /// Configuration for auto-capture behaviour.
  final AutoCaptureConfig autoCaptureConfig;

  /// Called when the frame has been stable long enough and auto-capture fires.
  /// Passes the stable [DocumentFrame] that triggered the capture, which can
  /// be used as a reliable fallback if detection on the final image fails.
  final void Function(DocumentFrame stableFrame) onAutoCaptureTriggered;

  const DocumentScannerView({
    super.key,
    required this.camera,
    this.debugStage = DebugStage.none,
    this.resolutionPreset = ResolutionPreset.medium,
    required this.onCameraReady,
    this.onFrameChanged,
    required this.liveEdgeDetectionEnabled,
    this.autoCaptureConfig = const AutoCaptureConfig(),
    required this.onAutoCaptureTriggered,
  });

  @override
  State<DocumentScannerView> createState() => _DocumentScannerViewState();
}

class _DocumentScannerViewState extends State<DocumentScannerView>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  DocumentFrame? _currentFrame;
  Size? _imageSize;
  ui.Image? _debugUiImage;

  final EdgeDetectionRunner _runner = EdgeDetectionRunner();

  /// Smoothing factor for the exponential moving average (0..1).
  /// Lower values produce smoother (but more laggy) corner positions.
  /// 0.3 gives a good balance between responsiveness and stability.
  static const _smoothingFactor = 0.3;

  /// Number of recent detection results to consider for stability.
  static const _stabilityWindowSize = 5;

  /// Minimum number of hits within the window to show the frame overlay.
  static const _minConsecutiveHits = 3;

  /// Rolling window of recent detection outcomes (`true` = frame found).
  final List<bool> _detectionHistory = [];

  DocumentFrame? _smoothedFrame;

  // --- Auto-capture ---
  late FrameStabilityTracker _stabilityTracker;
  late AnimationController _autoCaptureAnimController;
  bool _autoCaptureTriggered = false;
  DateTime _lastHapticTime = DateTime(0);

  @override
  void initState() {
    super.initState();
    _runner.start();
    _stabilityTracker = FrameStabilityTracker(widget.autoCaptureConfig);
    _autoCaptureAnimController =
        AnimationController(
            vsync: this,
            duration: widget.autoCaptureConfig.stableDuration,
          )
          ..addListener(_onAutoCaptureAnimTick)
          ..addStatusListener(_onAutoCaptureAnimStatus);
  }

  @override
  void didUpdateWidget(covariant DocumentScannerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.liveEdgeDetectionEnabled != widget.liveEdgeDetectionEnabled) {
      final controller = _controller;
      if (controller == null || !controller.value.isInitialized) return;
      if (widget.liveEdgeDetectionEnabled) {
        _startImageStream(controller);
      } else {
        _stopImageStream(controller);
      }
    }
    // Update tracker config if it changed.
    if (oldWidget.autoCaptureConfig != widget.autoCaptureConfig) {
      _stabilityTracker = FrameStabilityTracker(widget.autoCaptureConfig);
      _autoCaptureAnimController.duration =
          widget.autoCaptureConfig.stableDuration;
      _resetAutoCapture();
    }
  }

  @override
  void dispose() {
    _debugUiImage?.dispose();
    _runner.dispose();
    _autoCaptureAnimController.dispose();
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
              if (widget.liveEdgeDetectionEnabled &&
                  _currentFrame != null &&
                  _imageSize != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: FrameOverlayPainter(
                      frame: _currentFrame!,
                      imageSize: _imageSize!,
                      frameColor: Colors.white,
                    ),
                  ),
                ),
              // Auto-capture circular fill overlay.
              if (widget.autoCaptureConfig.enabled &&
                  _currentFrame != null &&
                  _imageSize != null)
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _autoCaptureAnimController,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: AutoCaptureOverlayPainter(
                          frame: _currentFrame!,
                          imageSize: _imageSize!,
                          progress: _autoCaptureAnimController.value,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.secondaryContainer.withOpacity(0.25),
                        ),
                      );
                    },
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
    _controller = controller;
    widget.onCameraReady(controller, width, height);
    if (widget.liveEdgeDetectionEnabled) {
      _startImageStream(controller);
    }
  }

  void _startImageStream(CameraController controller) {
    if (controller.value.isStreamingImages) return;

    if (widget.debugStage != DebugStage.none) {
      // Debug mode: process on main isolate to produce debug images.
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
      return;
    }

    // Production mode: offload to background isolate with frame skipping.
    controller.startImageStream((image) async {
      if (_runner.isProcessing) return;

      final prepared = prepareCameraImage(
        image,
        widget.camera.sensorOrientation,
        controller.value.deviceOrientation,
        widget.camera.lensDirection,
      );
      if (prepared == null) return;

      final outcome = await _runner.detect(
        rgbaBytes: prepared.bytes,
        width: prepared.width,
        height: prepared.height,
        rotationCompensation: prepared.rotation,
      );

      // null means skipped (still processing) — don't count.
      if (outcome == null) return;

      switch (outcome) {
        case FrameDetected(:final frame, :final imageSize):
          _onFrameReceived(frame, imageSize, null);
        case FrameNotFound():
          _onFrameMissed();
      }
    });
  }

  void _stopImageStream(CameraController controller) {
    if (!controller.value.isStreamingImages) return;
    controller.stopImageStream();
    setState(() {
      _currentFrame = null;
      _imageSize = null;
      _smoothedFrame = null;
      _detectionHistory.clear();
    });
    _resetAutoCapture();
    widget.onFrameChanged?.call(null, null);
  }

  void _onFrameReceived(
    DocumentFrame frame,
    Size imageSize,
    ui.Image? debugImage,
  ) async {
    _debugUiImage?.dispose();
    _debugUiImage = debugImage;

    _recordDetection(true);

    // Apply exponential moving average to smooth corners.
    final smoothed = _smoothedFrame == null
        ? frame
        : _smoothedFrame!.lerpTo(frame, _smoothingFactor);
    _smoothedFrame = smoothed;

    final stable = _isFrameStable;
    setState(() {
      _currentFrame = stable ? smoothed : null;
      _imageSize = stable ? imageSize : null;
    });
    widget.onFrameChanged?.call(
      stable ? smoothed : null,
      stable ? imageSize : null,
    );

    // --- Auto-capture tracking ---
    _updateAutoCapture(stable ? smoothed : null);
  }

  void _onFrameMissed() {
    _recordDetection(false);
    if (!_isFrameStable && _currentFrame != null) {
      _smoothedFrame = null;
      setState(() {
        _currentFrame = null;
        _imageSize = null;
      });
      widget.onFrameChanged?.call(null, null);
    }
    _updateAutoCapture(null);
  }

  // -----------------------------------------------------------------------
  // Auto-capture helpers
  // -----------------------------------------------------------------------

  void _updateAutoCapture(DocumentFrame? frame) {
    if (!widget.autoCaptureConfig.enabled || _autoCaptureTriggered) return;

    _stabilityTracker.update(frame);

    if (frame == null) {
      // No frame — stop the animation and reset.
      _resetAutoCapture();
      return;
    }

    if (_stabilityTracker.progress > 0 &&
        !_autoCaptureAnimController.isAnimating) {
      // Start the fill animation from wherever stability began.
      _autoCaptureAnimController.forward(from: 0.0);
    } else if (_stabilityTracker.progress <= 0 &&
        _autoCaptureAnimController.isAnimating) {
      _resetAutoCapture();
    }
  }

  void _resetAutoCapture() {
    _autoCaptureAnimController.reset();
    _stabilityTracker.reset();
    _autoCaptureTriggered = false;
  }

  void _onAutoCaptureAnimTick() {
    final progress = _autoCaptureAnimController.value;
    if (progress <= 0) return;

    // Haptic interval decreases as progress increases:
    // ~300ms at start → ~40ms near completion.
    final intervalMs = (300 - 260 * progress).round().clamp(40, 300);
    final now = DateTime.now();
    if (now.difference(_lastHapticTime).inMilliseconds < intervalMs) return;
    _lastHapticTime = now;

    if (progress < 0.33) {
      HapticFeedback.selectionClick();
    } else if (progress < 0.66) {
      HapticFeedback.lightImpact();
    } else if (progress < 0.9) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.heavyImpact();
    }
  }

  void _onAutoCaptureAnimStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_autoCaptureTriggered) {
      _autoCaptureTriggered = true;
      _stabilityTracker.markCaptured();
      final stableFrame = _stabilityTracker.stableFrame;
      if (stableFrame != null) {
        widget.onAutoCaptureTriggered(stableFrame);
      }
    }
  }

  void _recordDetection(bool hit) {
    _detectionHistory.add(hit);
    if (_detectionHistory.length > _stabilityWindowSize) {
      _detectionHistory.removeAt(0);
    }
  }

  bool get _isFrameStable {
    if (_detectionHistory.length < _minConsecutiveHits) return false;
    final hits = _detectionHistory.where((h) => h).length;
    return hits >= _minConsecutiveHits;
  }
}
