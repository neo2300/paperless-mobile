import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/data/debug_stage.dart';
import 'package:paperless_mobile_document_scanner/data/document_frame.dart';
import 'package:paperless_mobile_document_scanner/processing/detect_edges_from_file.dart';
import 'package:paperless_mobile_document_scanner/processing/perspective_transform.dart';
import 'package:paperless_mobile_document_scanner/view/auto_crop_preview_view.dart';
import 'package:paperless_mobile_document_scanner/view/document_scanner_view.dart';
import 'package:paperless_mobile_document_scanner/view/edge_adjustment_view.dart';
import 'package:paperless_mobile_document_scanner/view/image_edit_view.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/debug_stage_switcher.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/resolution_switcher.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/scan_preview_list.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/shutter_button.dart';
import 'package:path/path.dart' as p;

/// The phases of the scanning workflow.
enum _ScanPhase {
  /// Live camera preview with edge detection.
  liveDetection,

  /// Processing the captured image (edge detection + perspective transform).
  processing,

  /// Showing the auto-cropped result for accept/edit decision.
  autoCropPreview,

  /// Manual edge adjustment mode.
  edgeAdjustment,

  /// Post-crop image editing (rotate, B&W filter, etc.).
  imageEditing,
}

class DocumentScanner extends StatefulWidget {
  /// Called when the user completes the scan session.
  /// Receives all accepted scans as a list of image files.
  final ValueChanged<List<File>>? onFinished;

  /// Called when the user cancels the scan session.
  final VoidCallback? onCancelled;

  const DocumentScanner({super.key, this.onFinished, this.onCancelled});

  @override
  State<DocumentScanner> createState() => _DocumentScannerState();
}

class _DocumentScannerState extends State<DocumentScanner> {
  CameraController? _controller;
  DebugStage _debugStage = DebugStage.none;
  ResolutionPreset _resolutionPreset = ResolutionPreset.medium;
  bool _isTorchActive = false;

  _ScanPhase _phase = _ScanPhase.liveDetection;

  // Last detected frame from the live preview.
  DocumentFrame? _lastLiveFrame;

  // Captured image data.
  Uint8List? _capturedImageBytes;
  Size? _capturedImageSize;
  DocumentFrame? _capturedFrame;

  // Auto-cropped result.
  Uint8List? _autoCroppedBytes;

  // Bytes entering the image-edit phase (from auto-crop or edge adjustment).
  Uint8List? _editingBytes;

  // Path of the original captured image file (from takePicture).
  String? _capturedFilePath;

  // Accumulated scan files.
  final List<File> _scans = [];

  // -----------------------------------------------------------------------
  // Capture flow
  // -----------------------------------------------------------------------

  Future<void> _onShutterPressed() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    try {
      // Capture the image BEFORE switching phase, because changing phase
      // removes the camera view from the tree and disposes the controller.
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      final xFile = await controller.takePicture();
      final capturedPath = xFile.path;
      final bytes = await File(capturedPath).readAsBytes();

      if (!mounted) return;
      setState(() => _phase = _ScanPhase.processing);

      // Get image dimensions.
      final decoded = await decodeImageFromList(bytes);
      final imageSize = Size(
        decoded.width.toDouble(),
        decoded.height.toDouble(),
      );
      decoded.dispose();

      // Detect edges on the captured (full-res) image. Use the live-detected
      // frame as a sensible fallback if static detection fails.
      final detectedFrame = await detectEdgesFromImageBytes(bytes);
      final frame = detectedFrame ?? _lastLiveFrame;

      if (frame == null) {
        // No frame found at all — fallback to full image rectangle.
        _capturedFrame = DocumentFrame(
          topLeft: Offset.zero,
          topRight: Offset(imageSize.width, 0),
          bottomRight: Offset(imageSize.width, imageSize.height),
          bottomLeft: Offset(0, imageSize.height),
        );
      } else {
        _capturedFrame = frame;
      }

      _capturedImageBytes = bytes;
      _capturedImageSize = imageSize;
      _capturedFilePath = capturedPath;

      // Auto-crop immediately.
      final cropped = await perspectiveTransform(
        imageBytes: bytes,
        frame: _capturedFrame!,
      );

      if (mounted) {
        setState(() {
          _autoCroppedBytes = cropped;
          _phase = _ScanPhase.autoCropPreview;
        });
      }
    } catch (e) {
      debugPrint('Capture/crop failed: $e');
      if (mounted) _returnToLiveDetection();
    }
  }

  void _onAutoCropAccepted() {
    if (_autoCroppedBytes != null) {
      setState(() {
        _editingBytes = _autoCroppedBytes;
        _phase = _ScanPhase.imageEditing;
      });
    }
  }

  void _onAutoCropEditRequested() {
    setState(() => _phase = _ScanPhase.edgeAdjustment);
  }

  void _onAutoCropDiscarded() {
    _deleteOriginalCapture();
    _returnToLiveDetection();
  }

  void _onEdgeAdjustmentConfirmed(
    Uint8List transformedBytes,
    DocumentFrame adjustedFrame,
  ) {
    // Update the cropped preview and frame, then return to auto-crop view.
    setState(() {
      _autoCroppedBytes = transformedBytes;
      _capturedFrame = adjustedFrame;
      _phase = _ScanPhase.autoCropPreview;
    });
  }

  Future<void> _onImageEditConfirmed(Uint8List editedBytes) async {
    // Write the finished scan to a file.
    final scanFile = await _writeScanFile(editedBytes);
    _scans.add(scanFile);
    _deleteOriginalCapture();
    _returnToLiveDetection();
  }

  void _onImageEditCancelled() {
    // Return to auto-crop preview so the user can re-decide.
    setState(() {
      _editingBytes = null;
      _phase = _ScanPhase.autoCropPreview;
    });
  }

  void _onEdgeAdjustmentCancelled() {
    // Go back to auto-crop preview (the auto-cropped image is still available).
    setState(() => _phase = _ScanPhase.autoCropPreview);
  }

  void _onScanDeleted(int index) {
    final file = _scans.removeAt(index);
    file.delete().catchError((_) => file);
    setState(() {});
  }

  void _returnToLiveDetection() {
    setState(() {
      _phase = _ScanPhase.liveDetection;
      _capturedImageBytes = null;
      _capturedImageSize = null;
      _capturedFrame = null;
      _autoCroppedBytes = null;
      _editingBytes = null;
      _capturedFilePath = null;
    });
  }

  void _deleteOriginalCapture() {
    if (_capturedFilePath != null) {
      File(_capturedFilePath!).delete().catchError((_) => File(''));
      _capturedFilePath = null;
    }
  }

  /// Writes [bytes] to a new file in the system temp directory.
  Future<File> _writeScanFile(Uint8List bytes) async {
    final dir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(p.join(dir.path, 'scan_$timestamp.png'));
    return file.writeAsBytes(bytes, flush: true);
  }

  void _onFrameChanged(DocumentFrame? frame, Size? imageSize) {
    // Keep a reference to the last detected frame for the capture fallback.
    _lastLiveFrame = frame;
  }

  // -----------------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      _ScanPhase.processing => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      ),
      _ScanPhase.autoCropPreview => AutoCropPreviewView(
        croppedImageBytes: _autoCroppedBytes!,
        onAccepted: _onAutoCropAccepted,
        onEditRequested: _onAutoCropEditRequested,
        onDiscarded: _onAutoCropDiscarded,
      ),
      _ScanPhase.edgeAdjustment => EdgeAdjustmentView(
        imageBytes: _capturedImageBytes!,
        initialFrame: _capturedFrame!,
        imageSize: _capturedImageSize!,
        onConfirmed: _onEdgeAdjustmentConfirmed,
        onCancelled: _onEdgeAdjustmentCancelled,
      ),
      _ScanPhase.imageEditing => ImageEditView(
        imageBytes: _editingBytes!,
        onConfirmed: _onImageEditConfirmed,
        onCancelled: _onImageEditCancelled,
      ),
      _ScanPhase.liveDetection => _buildLiveDetection(),
    };
  }

  Widget _buildLiveDetection() {
    return FutureBuilder(
      future: availableCameras(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading cameras'));
        }

        final cameras = snapshot.data!;
        if (cameras.isEmpty) {
          return const Center(child: Text('No cameras found'));
        }
        final camera = cameras.first;
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: widget.onCancelled,
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
                if (_scans.isNotEmpty)
                  FilledButton.icon(
                    onPressed: () {
                      widget.onFinished?.call(List.of(_scans));
                    },
                    icon: const Icon(Icons.done_all),
                    label: Text('Done (${_scans.length})'),
                  ),
              ],
            ),
          ),
          body: Stack(
            children: [
              // Camera preview with live edge detection.
              DocumentScannerView(
                key: ValueKey(_resolutionPreset),
                onCameraReady: (controller, width, height) {
                  _controller = controller;
                },
                camera: camera,
                debugStage: _debugStage,
                resolutionPreset: _resolutionPreset,
                onFrameChanged: _onFrameChanged,
              ),
              // Scan preview list at the top.
              if (_scans.isNotEmpty)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    bottom: false,
                    child: ScanPreviewList(
                      scans: _scans,
                      onDelete: _onScanDeleted,
                    ),
                  ),
                ),
              // Shutter button.
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: RepaintBoundary(
                    child: ShutterButton(onPressed: _onShutterPressed),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 48, right: 16),
                  // The repaint boundary prevents aliasing artifacts when rendered on top of a platform view.
                  child: RepaintBoundary(child: _buildTorchButton()),
                ),
              ),
              // Debug/resolution controls.
              Positioned(
                top: _scans.isNotEmpty ? 100 : 8,
                right: 8,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DebugStageSwitcher(
                        value: _debugStage,
                        onChanged: (stage) =>
                            setState(() => _debugStage = stage),
                      ),
                      const SizedBox(height: 8),
                      ResolutionSwitcher(
                        value: _resolutionPreset,
                        onChanged: (preset) =>
                            setState(() => _resolutionPreset = preset),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTorchButton() {
    return IconButton.filledTonal(
      onPressed: () {
        _controller?.setFlashMode(
          _isTorchActive ? FlashMode.torch : FlashMode.off,
        );
        setState(() {
          _isTorchActive = !_isTorchActive;
        });
      },
      icon: Icon(_isTorchActive ? Icons.flash_off : Icons.flash_on, size: 32),
    );
  }
}
