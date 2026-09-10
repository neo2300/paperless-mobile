// ignore_for_file: invalid_annotation_target

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/features/settings/model/color_scheme_option.dart';
import 'package:paperless_mobile/features/settings/model/file_download_type.dart';
import 'package:paperless_mobile/features/scanner/models/scanner_parameters.dart';

part 'global_settings.g.dart';

@CopyWith()
@JsonSerializable()
class GlobalSettings {
  const GlobalSettings({
    required this.preferredLocaleSubtag,
    this.preferredThemeMode = ThemeMode.system,
    this.preferredColorSchemeOption = ColorSchemeOption.classic,
    this.showOnboarding = true,
    this.defaultDownloadType = FileDownloadType.alwaysAsk,
    this.defaultShareType = FileDownloadType.alwaysAsk,
    this.enforceSinglePagePdfUpload = false,
    this.skipDocumentPreprarationOnUpload = false,
    this.disableAnimations = false,
    this.knownHosts = const [],
    this.scannerParameters = const ScannerParameters(),
  });

  final String preferredLocaleSubtag;
  @JsonKey(toJson: _themeModeToJson, fromJson: _themeModeFromJson)
  final ThemeMode preferredThemeMode;
  final ColorSchemeOption preferredColorSchemeOption;
  final bool showOnboarding;
  final FileDownloadType defaultDownloadType;
  final FileDownloadType defaultShareType;

  /// Deprecated: scanner uploads are now always assembled as a PDF
  /// (including single-page scans), so this no longer has any effect on
  /// scanner upload behavior. The field (and its settings toggle) has been
  /// removed from the UI, but it is retained here — defaulting to `false`
  /// — purely so that existing persisted [GlobalSettings] JSON continues
  /// to (de)serialize without breaking previously stored user data.
  final bool enforceSinglePagePdfUpload;
  final bool skipDocumentPreprarationOnUpload;
  final bool disableAnimations;
  final List<String> knownHosts;
  final ScannerParameters scannerParameters;

  Map<String, dynamic> toJson() => _$GlobalSettingsToJson(this);
  factory GlobalSettings.fromJson(Map<String, dynamic> json) =>
      _$GlobalSettingsFromJson(json);
}

String _themeModeToJson(ThemeMode mode) {
  return mode.name;
}

ThemeMode _themeModeFromJson(String mode) {
  return ThemeMode.values.firstWhere(
    (e) => e.name == mode,
    orElse: () => ThemeMode.system,
  );
}
