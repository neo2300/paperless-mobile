import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/data/debug_stage.dart';
import 'package:paperless_mobile_document_scanner/data/document_frame.dart';
import 'package:paperless_mobile_document_scanner/data/scan_result.dart';
import 'package:paperless_mobile_document_scanner/processing/detect_edges_from_file.dart';
import 'package:paperless_mobile_document_scanner/processing/image_edit.dart';
import 'package:paperless_mobile_document_scanner/processing/perspective_transform.dart';
import 'package:paperless_mobile_document_scanner/view/document_scanner_view.dart';
import 'package:paperless_mobile_document_scanner/view/image_edit_view.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/debug_stage_switcher.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/resolution_switcher.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/scan_preview_list.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/shutter_button.dart';
import 'package:path/path.dart' as p;

enum _ScanPhase { liveDetection, processing, imageEditing }

const _shutterButtonSize = 72.0;
const _scanPreviewListHeight = 110.0;
const _actionButtonRowHeight = 56.0;

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

  DocumentFrame? _lastLiveFrame;

  // --- State for a new capture (used until the user confirms or discards). ---
  Uint8List? _capturedImageBytes;
  Size? _capturedImageSize;
  DocumentFrame? _capturedFrame;
  String? _capturedFilePath;
  Uint8List? _initialCroppedBytes;

  // --- Re-edit state ---
  /// Index into [_scans] when re-editing an existing scan, or `null` for a
  /// fresh capture.
  int? _editingIndex;

  // Accumulated scan results.
  final List<ScanResult> _scans = [];

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
          _initialCroppedBytes = cropped;
          _editingIndex = null;
          _phase = _ScanPhase.imageEditing;
        });
      }
    } catch (e) {
      debugPrint('Capture/crop failed: $e');
      if (mounted) _returnToLiveDetection();
    }
  }

  Future<void> _onImageEditConfirmed(ImageEditResult result) async {
    // Generate a lightweight thumbnail for the preview list.
    final thumbnail = await generateThumbnail(result.editedBytes);

    if (_editingIndex != null) {
      // Re-edit: update the existing scan in place.
      final existing = _scans[_editingIndex!];
      await existing.outputFile.writeAsBytes(result.editedBytes, flush: true);
      existing.cropFrame = result.cropFrame;
      existing.quarterTurns = result.quarterTurns;
      existing.colorFilter = result.colorFilter;
      existing.bwThreshold = result.bwThreshold;
      existing.thumbnailBytes = thumbnail;
    } else {
      // New scan: write the output file and create a ScanResult.
      final scanFile = await _writeScanFile(result.editedBytes);
      _scans.add(
        ScanResult(
          originalFile: File(_capturedFilePath!),
          originalImageSize: _capturedImageSize!,
          cropFrame: result.cropFrame,
          quarterTurns: result.quarterTurns,
          colorFilter: result.colorFilter,
          bwThreshold: result.bwThreshold,
          thumbnailBytes: thumbnail,
          outputFile: scanFile,
        ),
      );
    }

    _editingIndex = null;
    _returnToLiveDetection();
  }

  void _onImageEditCancelled() {
    if (_editingIndex == null) {
      // New capture discarded — delete the original capture file.
      _deleteOriginalCapture();
    }
    _editingIndex = null;
    _returnToLiveDetection();
  }

  void _onScanTapped(int index) {
    setState(() {
      _editingIndex = index;
      _phase = _ScanPhase.imageEditing;
    });
  }

  void _onScanDeleted(int index) {
    final scan = _scans.removeAt(index);
    scan.outputFile.delete().catchError((_) => scan.outputFile);
    scan.originalFile.delete().catchError((_) => scan.originalFile);
    setState(() {});
  }

  void _onScanReordered(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      final scan = _scans.removeAt(oldIndex);
      _scans.insert(newIndex, scan);
    });
  }

  void _returnToLiveDetection() {
    setState(() {
      _phase = _ScanPhase.liveDetection;
      _capturedImageBytes = null;
      _capturedImageSize = null;
      _capturedFrame = null;
      _initialCroppedBytes = null;
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

  @override
  Widget build(BuildContext context) {
    return switch (_phase) {
      _ScanPhase.processing => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      ),
      _ScanPhase.imageEditing => _buildImageEditing(),
      _ScanPhase.liveDetection => _buildLiveDetection(),
    };
  }

  Widget _buildImageEditing() {
    final scan = _editingIndex != null ? _scans[_editingIndex!] : null;

    if (scan != null) {
      // Re-edit: load from file on demand.
      return ImageEditView(
        originalImageFile: scan.originalFile,
        originalImageSize: scan.originalImageSize,
        initialCropFrame: scan.cropFrame,
        initialQuarterTurns: scan.quarterTurns,
        initialColorFilter: scan.colorFilter,
        initialBwThreshold: scan.bwThreshold,
        onConfirmed: _onImageEditConfirmed,
        onCancelled: _onImageEditCancelled,
      );
    }

    // New capture: bytes already in memory.
    return ImageEditView(
      originalImageBytes: _capturedImageBytes!,
      originalImageSize: _capturedImageSize!,
      initialCropFrame: _capturedFrame!,
      initialCroppedBytes: _initialCroppedBytes!,
      animateEntry: true,
      onConfirmed: _onImageEditConfirmed,
      onCancelled: _onImageEditCancelled,
    );
  }

  Widget _buildLiveDetection() {
    final bottomViewPadding = MediaQuery.of(context).viewPadding.bottom;
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
        final camera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
          orElse: () => cameras.first,
        );
        const bottomBarVerticalPadding = 8.0;
        final bottomBarHeight =
            _shutterButtonSize +
            _actionButtonRowHeight +
            (_scans.isNotEmpty ? _scanPreviewListHeight : 0) +
            2 *
                bottomBarVerticalPadding // x2 since it's applied both above and below the shutter row
                +
            bottomViewPadding;
        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            height: bottomBarHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shutter + torch row.
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: bottomBarVerticalPadding,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      RepaintBoundary(
                        child: ShutterButton(
                          onPressed: _onShutterPressed,
                          size: _shutterButtonSize,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: RepaintBoundary(child: _buildTorchButton()),
                        ),
                      ),
                    ],
                  ),
                ),
                // Cancel / Done buttons.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    height: _actionButtonRowHeight,
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
                              widget.onFinished?.call(
                                _scans.map((s) => s.outputFile).toList(),
                              );
                            },
                            icon: const Icon(Icons.done_all),
                            label: Text('Done (${_scans.length})'),
                          ),
                      ],
                    ),
                  ),
                ),
                // Scan preview list.
                if (_scans.isNotEmpty)
                  ScanPreviewList(
                    scans: _scans,
                    onDelete: _onScanDeleted,
                    onTap: _onScanTapped,
                    onReorder: _onScanReordered,
                    height: _scanPreviewListHeight,
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
              _buildDebugControls(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDebugControls() {
    return Positioned(
      top: 8,
      right: 8,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DebugStageSwitcher(
              value: _debugStage,
              onChanged: (stage) => setState(() => _debugStage = stage),
            ),
            const SizedBox(height: 8),
            ResolutionSwitcher(
              value: _resolutionPreset,
              onChanged: (preset) => setState(() => _resolutionPreset = preset),
            ),
          ],
        ),
      ),
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
