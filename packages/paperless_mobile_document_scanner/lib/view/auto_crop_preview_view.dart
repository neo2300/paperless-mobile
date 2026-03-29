import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Shows the auto-cropped (perspective-transformed) image with an entry
/// animation and gives the user two options: accept or manually edit the crop.
class AutoCropPreviewView extends StatefulWidget {
  /// The perspective-transformed image (PNG bytes).
  final Uint8List croppedImageBytes;

  /// Called when the user accepts the auto-crop result.
  final VoidCallback onAccepted;

  /// Called when the user wants to manually edit the crop area.
  final VoidCallback onEditRequested;

  /// Called when the user discards this capture entirely.
  final VoidCallback onDiscarded;

  const AutoCropPreviewView({
    super.key,
    required this.croppedImageBytes,
    required this.onAccepted,
    required this.onEditRequested,
    required this.onDiscarded,
  });

  @override
  State<AutoCropPreviewView> createState() => _AutoCropPreviewViewState();
}

class _AutoCropPreviewViewState extends State<AutoCropPreviewView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _opacityAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Preview')),
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return Stack(
            children: [
              // Background fade-in.
              Opacity(
                opacity: _opacityAnimation.value,
                child: Container(color: Colors.black),
              ),
              Center(
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        widget.croppedImageBytes,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: widget.onDiscarded, child: Text('Discard')),
            IconButton(
              onPressed: widget.onEditRequested,
              icon: const Icon(Icons.crop),
              tooltip: 'Edit crop',
            ),
            FilledButton.icon(
              onPressed: widget.onAccepted,
              icon: const Icon(Icons.arrow_forward),
              iconAlignment: IconAlignment.end,
              label: Text(
                MaterialLocalizations.of(context).continueButtonLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
