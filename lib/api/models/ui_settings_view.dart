//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/src/equatable_utils.dart';
import 'package:json_annotation/json_annotation.dart';
// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/ui_settings_view_settings.dart';
import 'package:paperless_mobile/api/models/ui_settings_view_user.dart';

part 'ui_settings_view.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UiSettingsView {
  /// Returns a new [UiSettingsView] instance.
  UiSettingsView({this.permissions, this.settings, required this.user});

  @JsonKey(name: r'permissions', includeIfNull: false)
  final List<String>? permissions;

  @JsonKey(name: r'settings', includeIfNull: false)
  final UiSettingsViewSettings? settings;

  @JsonKey(name: r'user', includeIfNull: false)
  final UiSettingsViewUser user;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is UiSettingsView &&
            runtimeType == other.runtimeType &&
            equals(
              [permissions, settings, user],
              [other.permissions, other.settings, other.user],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ mapPropsToHashCode([permissions, settings, user]);

  factory UiSettingsView.fromJson(Map<String, dynamic> json) =>
      _$UiSettingsViewFromJson(json);

  Map<String, dynamic> toJson() => _$UiSettingsViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
