import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_profile_request.freezed.dart';
part 'patched_profile_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedProfileRequest with _$PatchedProfileRequest {
  factory PatchedProfileRequest({
    Option<String?>? email,
    Option<String?>? password,
    Option<String?>? firstName,
    Option<String?>? lastName,
  }) = _PatchedProfileRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedProfileRequestToJson(this as _PatchedProfileRequest),
  );
}
