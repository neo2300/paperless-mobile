import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/data/document_frame.dart';
import 'package:paperless_mobile_document_scanner/processing/perspective_transform.dart';
import 'package:paperless_mobile_document_scanner/view/widgets/draggable_frame_overlay_painter.dart';

/// A view that displays a captured image with a pre-detected document frame.
///
/// The user can drag the 4 corner points to adjust the selection, then press
/// "Done" to apply a perspective transform that rectifies the selected region
/// into a proper rectangle.
class EdgeAdjustmentView extends StatefulWidget {
  /// Raw bytes (PNG/JPEG) of the captured image.
  final Uint8List imageBytes;

  /// The initial document frame (from live detection) to display.
  final DocumentFrame initialFrame;

  /// The size of the original image in pixels.
  final Size imageSize;

  /// Called when the user confirms the adjusted selection.
  /// Receives the perspective-transformed image as PNG bytes and the adjusted frame.
  final void Function(Uint8List transformedBytes, DocumentFrame adjustedFrame)
  onConfirmed;

  /// Called when the user cancels / goes back.
  final VoidCallback onCancelled;

  const EdgeAdjustmentView({
    super.key,
    required this.imageBytes,
    required this.initialFrame,
    required this.imageSize,
    required this.onConfirmed,
    required this.onCancelled,
  });

  @override
  State<EdgeAdjustmentView> createState() => _EdgeAdjustmentViewState();
}

enum _Corner { topLeft, topRight, bottomRight, bottomLeft }

class _EdgeAdjustmentViewState extends State<EdgeAdjustmentView> {
  late DocumentFrame _frame;
  bool _isProcessing = false;
  _Corner? _activeCorner;
  ui.Image? _decodedImage;

  @override
  void initState() {
    super.initState();
    _frame = widget.initialFrame;
    _decodeImage();
  }

  Future<void> _decodeImage() async {
    final image = await decodeImageFromList(widget.imageBytes);
    if (mounted) {
      setState(() => _decodedImage = image);
    }
  }

  @override
  void dispose() {
    _decodedImage?.dispose();
    super.dispose();
  }

  Future<void> _onDone() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final result = await perspectiveTransform(
        imageBytes: widget.imageBytes,
        frame: _frame,
      );
      widget.onConfirmed(result, _frame);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Transform failed: $e')));
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Adjust edges')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onCancelled,
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton.icon(
              onPressed: _onDone,
              icon: _isProcessing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.done),
              label: Text('Done'),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanStart: (details) => _onPanStart(details, constraints),
            onPanUpdate: (details) => _onPanUpdate(details, constraints),
            onPanEnd: (_) => setState(() => _activeCorner = null),
            child: Stack(
              children: [
                // Rendered image.
                Center(
                  child: Image.memory(
                    widget.imageBytes,
                    fit: BoxFit.contain,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  ),
                ),
                // Edge overlay with draggable corners.
                Positioned.fill(
                  child: CustomPaint(
                    painter: DraggableFrameOverlayPainter(
                      frame: _frame,
                      imageSize: widget.imageSize,
                      frameColor: Theme.of(context).colorScheme.primary,
                      activeCornerIndex: _activeCorner != null
                          ? _Corner.values.indexOf(_activeCorner!)
                          : null,
                      sourceImage: _decodedImage,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Transforms image coordinates to widget coordinates using BoxFit.contain.
  Offset _imageToWidget(Offset imagePos, BoxConstraints constraints) {
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final scaleX = size.width / widget.imageSize.width;
    final scaleY = size.height / widget.imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    final offsetX = (size.width - widget.imageSize.width * scale) / 2;
    final offsetY = (size.height - widget.imageSize.height * scale) / 2;

    return Offset(imagePos.dx * scale + offsetX, imagePos.dy * scale + offsetY);
  }

  void _onPanStart(DragStartDetails details, BoxConstraints constraints) {
    final touchPos = details.localPosition;

    // Find the closest corner to the touch point (no hit-radius restriction).
    final corners = {
      _Corner.topLeft: _imageToWidget(_frame.topLeft, constraints),
      _Corner.topRight: _imageToWidget(_frame.topRight, constraints),
      _Corner.bottomRight: _imageToWidget(_frame.bottomRight, constraints),
      _Corner.bottomLeft: _imageToWidget(_frame.bottomLeft, constraints),
    };

    double? minDist;
    _Corner? closest;
    for (final entry in corners.entries) {
      final dist = (entry.value - touchPos).distance;
      if (minDist == null || dist < minDist) {
        minDist = dist;
        closest = entry.key;
      }
    }

    _activeCorner = closest;
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    if (_activeCorner == null) return;

    // Convert the gesture delta to image-space and apply it to the corner.
    // Dampen the movement so precision adjustments are easier.
    const dampingFactor = 0.3;
    final size = Size(constraints.maxWidth, constraints.maxHeight);
    final scaleX = size.width / widget.imageSize.width;
    final scaleY = size.height / widget.imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;
    final imageDelta = Offset(
      details.delta.dx / scale * dampingFactor,
      details.delta.dy / scale * dampingFactor,
    );

    final currentPos = switch (_activeCorner!) {
      _Corner.topLeft => _frame.topLeft,
      _Corner.topRight => _frame.topRight,
      _Corner.bottomRight => _frame.bottomRight,
      _Corner.bottomLeft => _frame.bottomLeft,
    };

    final newPos = Offset(
      (currentPos.dx + imageDelta.dx).clamp(0.0, widget.imageSize.width),
      (currentPos.dy + imageDelta.dy).clamp(0.0, widget.imageSize.height),
    );

    setState(() {
      _frame = DocumentFrame(
        topLeft: _activeCorner == _Corner.topLeft ? newPos : _frame.topLeft,
        topRight: _activeCorner == _Corner.topRight ? newPos : _frame.topRight,
        bottomRight: _activeCorner == _Corner.bottomRight
            ? newPos
            : _frame.bottomRight,
        bottomLeft: _activeCorner == _Corner.bottomLeft
            ? newPos
            : _frame.bottomLeft,
      );
    });
  }
}
