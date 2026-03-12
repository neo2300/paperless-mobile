import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/file_version_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_share_link_request.freezed.dart';
part 'patched_share_link_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedShareLinkRequest with _$PatchedShareLinkRequest {
  factory PatchedShareLinkRequest({
    Option<DateTime?>? expiration,
    Option<int?>? document,
    Option<FileVersionEnum?>? fileVersion,
  }) = _PatchedShareLinkRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedShareLinkRequestToJson(this as _PatchedShareLinkRequest),
  );
}
