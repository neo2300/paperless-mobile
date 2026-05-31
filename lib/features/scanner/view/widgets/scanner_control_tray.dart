import 'package:flutter/material.dart';
import 'package:paperless_mobile/generated/l10n/app_localizations.dart';

class ScannerControlTray extends StatefulWidget {
  final bool liveDetectionEnabled;
  final bool autoCaptureRequested;
  final ValueChanged<bool> onLiveDetectionChanged;
  final ValueChanged<bool> onAutoCaptureChanged;

  const ScannerControlTray({
    super.key,
    required this.liveDetectionEnabled,
    required this.autoCaptureRequested,
    required this.onLiveDetectionChanged,
    required this.onAutoCaptureChanged,
  });

  @override
  State<ScannerControlTray> createState() => _ScannerControlTrayState();
}

class _ScannerControlTrayState extends State<ScannerControlTray> {
  bool _expanded = false;

  bool get _autoCaptureActive =>
      widget.liveDetectionEnabled && widget.autoCaptureRequested;

  String get _statusText {
    if (_autoCaptureActive) {
      return S.of(context)!.autoCaptureModeEnabled;
    }
    if (widget.liveDetectionEnabled) {
      return S.of(context)!.liveDetectionEnabled;
    }
    if (widget.autoCaptureRequested) {
      return S.of(context)!.autoCaptureDisabled;
    }
    return S.of(context)!.scanAssistDisabled;
  }

  IconData get _statusIcon {
    if (_autoCaptureActive) {
      return Icons.motion_photos_auto;
    }
    if (widget.liveDetectionEnabled) {
      return Icons.fiber_manual_record_outlined;
    }
    return Icons.visibility_outlined;
  }

  Color _statusColor(ColorScheme colorScheme) {
    if (_autoCaptureActive) {
      return colorScheme.primary;
    }
    if (widget.liveDetectionEnabled) {
      return colorScheme.tertiary;
    }
    return colorScheme.outline;
  }

  void _toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 200),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            ...previousChildren,
            ...?currentChild == null ? null : [currentChild],
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.86, end: 1).animate(animation),
            alignment: Alignment.bottomRight,
            child: child,
          ),
        );
      },
      child: _expanded
          ? _buildExpandedTray(theme, colorScheme)
          : _buildCollapsedFab(theme, colorScheme),
    );
  }

  Widget _buildExpandedTray(ThemeData theme, ColorScheme colorScheme) {
    return ConstrainedBox(
      key: const ValueKey('expanded-tray'),
      constraints: const BoxConstraints(maxWidth: 300),
      child: Material(
        elevation: 10,
        color: colorScheme.surface.withValues(alpha: 0.94),
        shadowColor: Colors.black.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.tune,
                      size: 20,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context)!.scanAssist,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeInCubic,
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SizeTransition(
                                sizeFactor: animation,
                                axisAlignment: -1,
                                child: child,
                              ),
                            );
                          },
                          child: Row(
                            key: ValueKey(_statusText),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _statusIcon,
                                size: 14,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _statusText,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: _toggleExpanded,
                    tooltip: S.of(context)!.collapseScanSettingsTooltip,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: IconButton.styleFrom(
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      foregroundColor: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ScannerControlTile(
                icon: Icons.document_scanner_outlined,
                label: S.of(context)!.liveDetection,
                description: S.of(context)!.liveDetectionDescription,
                value: widget.liveDetectionEnabled,
                enabled: true,
                onChanged: widget.onLiveDetectionChanged,
              ),
              const SizedBox(height: 8),
              _ScannerControlTile(
                icon: Icons.motion_photos_auto_outlined,
                label: S.of(context)!.autoCapture,
                description: widget.liveDetectionEnabled
                    ? S.of(context)!.autoCaptureDescription
                    : widget.autoCaptureRequested
                    ? S.of(context)!.autoCaptureReEnableDescription
                    : S.of(context)!.autoCaptureDisabledDescription,
                value: _autoCaptureActive,
                enabled: widget.liveDetectionEnabled,
                onChanged: widget.onAutoCaptureChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollapsedFab(ThemeData theme, ColorScheme colorScheme) {
    final statusColor = _statusColor(colorScheme);
    return Stack(
      key: const ValueKey('collapsed-fab'),
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: FloatingActionButton(
            onPressed: _toggleExpanded,
            backgroundColor: colorScheme.surface.withValues(alpha: 0.96),
            foregroundColor: colorScheme.onSurface,
            elevation: 10,
            heroTag: null,
            child: const Icon(Icons.tune, size: 30),
          ),
        ),
        Positioned(
          right: 1,
          bottom: 1,
          child: IgnorePointer(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.surface, width: 2),
              ),
              child: Icon(_statusIcon, size: 12, color: colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ScannerControlTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _ScannerControlTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final foregroundColor = enabled
        ? (value ? colorScheme.onPrimaryContainer : colorScheme.onSurface)
        : colorScheme.onSurface.withValues(alpha: 0.6);
    final descriptionColor = enabled
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSurfaceVariant.withValues(alpha: 0.65);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: enabled
            ? (value
                  ? colorScheme.primaryContainer.withValues(alpha: 0.9)
                  : colorScheme.surfaceContainerHigh.withValues(alpha: 0.72))
            : colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: value
              ? colorScheme.primary.withValues(alpha: 0.45)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: enabled ? () => onChanged(!value) : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: enabled
                        ? (value
                              ? colorScheme.primary.withValues(alpha: 0.14)
                              : colorScheme.surface)
                        : colorScheme.surface.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: foregroundColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: foregroundColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        child: Text(
                          description,
                          key: ValueKey(description),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: descriptionColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IgnorePointer(
                  child: Switch.adaptive(
                    value: value,
                    onChanged: enabled ? onChanged : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
