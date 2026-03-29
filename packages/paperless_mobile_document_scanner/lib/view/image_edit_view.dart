import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:paperless_mobile_document_scanner/data/document_frame.dart';
import 'package:paperless_mobile_document_scanner/data/scan_result.dart';
import 'package:paperless_mobile_document_scanner/processing/image_edit.dart';
import 'package:paperless_mobile_document_scanner/processing/perspective_transform.dart';
import 'package:paperless_mobile_document_scanner/view/edge_adjustment_view.dart';

/// Result returned by [ImageEditView] when the user confirms their edits.
class ImageEditResult {
  final DocumentFrame cropFrame;
  final int quarterTurns;
  final ScanColorFilter colorFilter;
  final double bwThreshold;
  final Uint8List editedBytes;

  ImageEditResult({
    required this.cropFrame,
    required this.quarterTurns,
    required this.colorFilter,
    required this.bwThreshold,
    required this.editedBytes,
  });
}

/// Combined editing view: crop adjustment (via edge adjustment sub-page),
/// rotation, and colour filters.
///
/// For a **new capture**, pass [originalImageBytes] and [initialCroppedBytes]
/// directly.  For a **re-edit** of an existing scan, pass [originalImageFile]
/// instead — the bytes will be loaded from disk on demand.
class ImageEditView extends StatefulWidget {
  /// Raw bytes of the original captured image (new capture path).
  /// Mutually exclusive with [originalImageFile].
  final Uint8List? originalImageBytes;

  /// Original image file on disk (re-edit path). The bytes will be loaded
  /// lazily. Mutually exclusive with [originalImageBytes].
  final File? originalImageFile;

  /// Pixel dimensions of the original image.
  final Size originalImageSize;

  /// The initial crop frame (from detection or a previous edit).
  final DocumentFrame initialCropFrame;

  /// Pre-computed perspective-transformed bytes for [initialCropFrame].
  /// Required when [originalImageBytes] is set (new capture). When null,
  /// the view will compute it from the file on init.
  final Uint8List? initialCroppedBytes;

  /// Initial rotation (0–3 quarter turns clockwise).
  final int initialQuarterTurns;

  /// Initial color filter.
  final ScanColorFilter initialColorFilter;

  /// Initial B&W threshold.
  final double initialBwThreshold;

  /// Whether to play the entry animation (scale + opacity).
  final bool animateEntry;

  /// Called when the user confirms the edits.
  final ValueChanged<ImageEditResult> onConfirmed;

  /// Called when the user cancels / discards.
  final VoidCallback onCancelled;

  const ImageEditView({
    super.key,
    this.originalImageBytes,
    this.originalImageFile,
    required this.originalImageSize,
    required this.initialCropFrame,
    this.initialCroppedBytes,
    this.initialQuarterTurns = 0,
    this.initialColorFilter = ScanColorFilter.none,
    this.initialBwThreshold = 10,
    this.animateEntry = false,
    required this.onConfirmed,
    required this.onCancelled,
  }) : assert(
         originalImageBytes != null || originalImageFile != null,
         'Either originalImageBytes or originalImageFile must be provided',
       );

  @override
  State<ImageEditView> createState() => _ImageEditViewState();
}

class _ImageEditViewState extends State<ImageEditView>
    with SingleTickerProviderStateMixin {
  late DocumentFrame _cropFrame;
  Uint8List? _originalBytes;
  Uint8List? _croppedBytes;
  Uint8List? _displayBytes;
  late ScanColorFilter _colorFilter;
  late double _bwThreshold;
  late int _quarterTurns;
  bool _processing = false;
  bool _loading = false;

  // Entry animation (only when animateEntry is true).
  AnimationController? _animController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _cropFrame = widget.initialCropFrame;
    _quarterTurns = widget.initialQuarterTurns;
    _colorFilter = widget.initialColorFilter;
    _bwThreshold = widget.initialBwThreshold;

    if (widget.originalImageBytes != null) {
      // New capture — bytes already available.
      _originalBytes = widget.originalImageBytes;
      _croppedBytes = widget.initialCroppedBytes;
      _displayBytes = _croppedBytes;
      if (_quarterTurns != 0 || _colorFilter != ScanColorFilter.none) {
        _applyEdits();
      }
    } else {
      // Re-edit — load from file and recompute.
      _loading = true;
      _loadFromFile();
    }

    if (widget.animateEntry) {
      _animController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
      _scaleAnimation = CurvedAnimation(
        parent: _animController!,
        curve: Curves.easeOutCubic,
      );
      _opacityAnimation = CurvedAnimation(
        parent: _animController!,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      );
      _animController!.forward();
    }
  }

  Future<void> _loadFromFile() async {
    try {
      final bytes = await widget.originalImageFile!.readAsBytes();
      final cropped = await perspectiveTransform(
        imageBytes: bytes,
        frame: _cropFrame,
      );
      _originalBytes = bytes;
      _croppedBytes = cropped;

      if (_quarterTurns != 0 || _colorFilter != ScanColorFilter.none) {
        // _applyEdits will set _displayBytes and _loading = false.
        if (mounted) setState(() => _loading = false);
        await _applyEdits();
      } else {
        if (mounted) {
          setState(() {
            _displayBytes = _croppedBytes;
            _loading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Failed to load original image: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _animController?.dispose();
    super.dispose();
  }

  // -----------------------------------------------------------------------
  // Editing operations
  // -----------------------------------------------------------------------

  Future<void> _applyEdits() async {
    if (_processing || _croppedBytes == null) return;
    setState(() => _processing = true);

    try {
      // Always start from the cropped bytes to avoid compounding quality loss.
      Uint8List result = _croppedBytes!;

      if (_quarterTurns % 4 != 0) {
        result = await rotateImage(result, _quarterTurns);
      }

      switch (_colorFilter) {
        case ScanColorFilter.greyscale:
          result = await toGrayscale(result);
        case ScanColorFilter.blackAndWhite:
          result = await toBlackAndWhite(result, constant: _bwThreshold);
        case ScanColorFilter.none:
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

  void _setColorFilter(ScanColorFilter filter) {
    _colorFilter = _colorFilter == filter ? ScanColorFilter.none : filter;
    _applyEdits();
  }

  Future<void> _onCropPressed() async {
    if (_originalBytes == null) return;
    final result = await Navigator.of(context).push<(Uint8List, DocumentFrame)>(
      MaterialPageRoute(
        builder: (navContext) => EdgeAdjustmentView(
          imageBytes: _originalBytes!,
          initialFrame: _cropFrame,
          imageSize: widget.originalImageSize,
          onConfirmed: (bytes, frame) {
            Navigator.of(navContext).pop((bytes, frame));
          },
          onCancelled: () {
            Navigator.of(navContext).pop();
          },
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _croppedBytes = result.$1;
        _cropFrame = result.$2;
      });
      _applyEdits();
    }
  }

  void _onDone() {
    if (_displayBytes == null) return;
    widget.onConfirmed(
      ImageEditResult(
        cropFrame: _cropFrame,
        quarterTurns: _quarterTurns,
        colorFilter: _colorFilter,
        bwThreshold: _bwThreshold,
        editedBytes: _displayBytes!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool showLoading = _loading || _displayBytes == null;

    Widget imageWidget;
    if (showLoading) {
      imageWidget = const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else {
      imageWidget = Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.memory(
            _displayBytes!,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          ),
        ),
      );
    }

    // Wrap with entry animation when requested.
    if (_animController != null) {
      imageWidget = AnimatedBuilder(
        animation: _animController!,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityAnimation!.value,
            child: ScaleTransition(scale: _scaleAnimation!, child: child),
          );
        },
        child: imageWidget,
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Edit')),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: widget.onCancelled,
              child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
            ),
            FilledButton.icon(
              onPressed: (_processing || showLoading) ? null : _onDone,
              icon: const Icon(Icons.check),
              label: const Text('Apply'),
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
                  imageWidget,
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
                if (_colorFilter == ScanColorFilter.blackAndWhite)
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        theme.bottomAppBarTheme.color ??
                        theme.colorScheme.surfaceContainer,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _EditButton(
                          icon: Icons.crop,
                          label: 'Crop',
                          onPressed: _processing ? null : _onCropPressed,
                        ),
                        _EditButton(
                          icon: Icons.rotate_90_degrees_ccw,
                          label: 'Rotate left',
                          onPressed: _processing
                              ? null
                              : _rotateCounterClockwise,
                        ),
                        _EditButton(
                          icon: Icons.rotate_90_degrees_cw,
                          label: 'Rotate right',
                          onPressed: _processing ? null : _rotateClockwise,
                        ),
                        _EditButton(
                          icon: Icons.gradient,
                          label: 'Greyscale',
                          isActive: _colorFilter == ScanColorFilter.greyscale,
                          onPressed: _processing
                              ? null
                              : () =>
                                    _setColorFilter(ScanColorFilter.greyscale),
                          activeColor: theme.colorScheme.primary,
                        ),
                        _EditButton(
                          icon: Icons.filter_b_and_w,
                          label: 'B & W',
                          isActive:
                              _colorFilter == ScanColorFilter.blackAndWhite,
                          onPressed: _processing
                              ? null
                              : () => _setColorFilter(
                                  ScanColorFilter.blackAndWhite,
                                ),
                          activeColor: theme.colorScheme.primary,
                        ),
                      ],
                    ),
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
