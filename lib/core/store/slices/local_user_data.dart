import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/core/store/slices/local_user_app_state.dart';

part 'local_user_data.freezed.dart';
part 'local_user_data.g.dart';

@freezed
abstract class LocalUserData with _$LocalUserData {
  const LocalUserData._();

  const factory LocalUserData({
    required String userId,
    required String serverUrl,
    required String username,
    String? firstName,
    String? lastName,
    @Default(false) bool isBiometricAuthenticationEnabled,
    @Default(LocalUserAppState()) LocalUserAppState appState,
  }) = _UserSettings;

  factory LocalUserData.fromJson(Map<String, dynamic> json) =>
      _$LocalUserDataFromJson(json);

  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    } else {
      return username;
    }
  }
}
