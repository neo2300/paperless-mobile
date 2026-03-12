import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_user_request.freezed.dart';
part 'patched_user_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedUserRequest with _$PatchedUserRequest {
  factory PatchedUserRequest({
    /// Required. 150 characters or fewer. Letters, digits and @/./+/-/_ only.
    Option<String?>? username,
    Option<String?>? email,
    Option<String?>? password,
    Option<String?>? firstName,
    Option<String?>? lastName,
    Option<DateTime?>? dateJoined,

    /// Designates whether the user can log into this admin site.
    Option<bool?>? isStaff,

    /// Designates whether this user should be treated as active. Unselect this instead of deleting accounts.
    Option<bool?>? isActive,

    /// Designates that this user has all permissions without explicitly assigning them.
    Option<bool?>? isSuperuser,

    /// The groups this user belongs to. A user will get all permissions granted to each of their groups.
    Option<List<int>?>? groups,
    Option<List<String>?>? userPermissions,
  }) = _PatchedUserRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedUserRequestToJson(this as _PatchedUserRequest),
  );
}
