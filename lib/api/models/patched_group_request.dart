import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_group_request.freezed.dart';
part 'patched_group_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedGroupRequest with _$PatchedGroupRequest {
  factory PatchedGroupRequest({
    Option<String?>? name,
    Option<List<String>?>? permissions,
  }) = _PatchedGroupRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedGroupRequestToJson(this as _PatchedGroupRequest),
  );
}
