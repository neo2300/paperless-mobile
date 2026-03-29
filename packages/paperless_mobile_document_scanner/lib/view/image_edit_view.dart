import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/processing/image_edit.dart';

enum _ColorFilter { none, greyscale, blackAndWhite }

/// Post-crop editing view that allows the user to rotate the image (90° steps)
/// and apply a greyscale or black-and-white filter before accepting.
class ImageEditView extends StatefulWidget {
  /// The cropped image (PNG bytes) to edit.
  final Uint8List imageBytes;

  /// Called when the user confirms the edits.
  final ValueChanged<Uint8List> onConfirmed;

  /// Called when the user cancels editing and wants to go back.
  final VoidCallback onCancelled;

  const ImageEditView({
    super.key,
    required this.imageBytes,
    required this.onConfirmed,
    required this.onCancelled,
  });

  @override
  State<ImageEditView> createState() => _ImageEditViewState();
}

class _ImageEditViewState extends State<ImageEditView> {
  late Uint8List _displayBytes;
  _ColorFilter _colorFilter = _ColorFilter.none;
  bool _processing = false;

  /// B&W adaptive threshold constant (2–30). Higher = more black.
  double _bwThreshold = 10;

  /// How many 90° clockwise turns have been applied (0–3).
  int _quarterTurns = 0;

  @override
  void initState() {
    super.initState();
    _displayBytes = widget.imageBytes;
  }

  // -----------------------------------------------------------------------
  // Editing operations
  // -----------------------------------------------------------------------

  Future<void> _applyEdits() async {
    if (_processing) return;
    setState(() => _processing = true);

    try {
      // Always start from the original to avoid compounding quality loss.
      Uint8List result = widget.imageBytes;

      if (_quarterTurns % 4 != 0) {
        result = await rotateImage(result, _quarterTurns);
      }

      switch (_colorFilter) {
        case _ColorFilter.greyscale:
          result = await toGrayscale(result);
          break;
        case _ColorFilter.blackAndWhite:
          result = await toBlackAndWhite(result, constant: _bwThreshold);
          break;
        case _ColorFilter.none:
          break;
      }

      if (mounted) {
        setState(() {
          _displayBytes = result;
          _processing = false;
        });
      }
    } catch (e) {
      debugPrint('Image edit failed: $e');
      if (mounted) setState(() => _processing = false);
    }
  }

  void _rotateClockwise() {
    _quarterTurns = (_quarterTurns + 1) % 4;
    _applyEdits();
  }

  void _rotateCounterClockwise() {
    _quarterTurns = (_quarterTurns + 3) % 4; // +3 ≡ -1 mod 4
    _applyEdits();
  }

  void _setColorFilter(_ColorFilter filter) {
    // Toggle off if already active, otherwise switch.
    _colorFilter = _colorFilter == filter ? _ColorFilter.none : filter;
    _applyEdits();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Edit')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onCancelled,
              child: Text(MaterialLocalizations.of(context).backButtonTooltip),
            ),
            FilledButton.icon(
              onPressed: _processing
                  ? null
                  : () => widget.onConfirmed(_displayBytes),
              icon: const Icon(Icons.check),
              label: Text('Done'),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Image preview.
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _displayBytes,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  if (_processing)
                    const CircularProgressIndicator(color: Colors.white),
                ],
              ),
            ),
          ),
          // Editing controls.
          SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_colorFilter == _ColorFilter.blackAndWhite)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.brightness_low,
                          color: Colors.white70,
                          size: 20,
                        ),
                        Expanded(
                          child: Slider(
                            value: _bwThreshold,
                            min: 2,
                            max: 30,
                            divisions: 28,
                            label: _bwThreshold.round().toString(),
                            onChanged: _processing
                                ? null
                                : (value) {
                                    setState(() => _bwThreshold = value);
                                  },
                            onChangeEnd: _processing
                                ? null
                                : (_) => _applyEdits(),
                          ),
                        ),
                        const Icon(
                          Icons.brightness_high,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        theme.bottomAppBarTheme.color ??
                        theme.colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _EditButton(
                        icon: Icons.rotate_90_degrees_ccw,
                        onPressed: _processing ? null : _rotateCounterClockwise,
                        label: "Rotate left",
                      ),
                      _EditButton(
                        icon: Icons.rotate_90_degrees_cw,
                        onPressed: _processing ? null : _rotateClockwise,
                        label: "Rotate right",
                      ),
                      _EditButton(
                        icon: Icons.gradient,
                        label: 'Greyscale',
                        isActive: _colorFilter == _ColorFilter.greyscale,
                        onPressed: _processing
                            ? null
                            : () => _setColorFilter(_ColorFilter.greyscale),
                        activeColor: theme.colorScheme.primary,
                      ),
                      _EditButton(
                        icon: Icons.filter_b_and_w,
                        label: 'B & W',
                        isActive: _colorFilter == _ColorFilter.blackAndWhite,
                        onPressed: _processing
                            ? null
                            : () => _setColorFilter(_ColorFilter.blackAndWhite),
                        activeColor: theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback? onPressed;
  final bool isActive;
  final Color? activeColor;

  const _EditButton({
    required this.icon,

    this.label,
    this.onPressed,
    this.isActive = false,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : null;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(label!, style: TextStyle(color: color, fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }
}
