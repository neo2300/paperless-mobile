import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/user.dart';
import 'package:paperless_mobile/core/store/slices/user_profile.dart';

part 'local_user_account.freezed.dart';
part 'local_user_account.g.dart';

@freezed
abstract class LocalUserAccount with _$LocalUserAccount {
  const factory LocalUserAccount({
    required String appUserId,
    required String serverUrl,
    required UserProfile profile,
    @Deprecated('will be null going forward, use profile instead')
    User? paperlessUser,
    required int apiVersion,
  }) = _LocalUserAccount;

  factory LocalUserAccount.fromJson(Map<String, dynamic> json) =>
      _$LocalUserAccountFromJson(json);
}
