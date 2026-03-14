import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/converters/optional_json_converter.dart';
import 'package:paperless_mobile/api/models/correspondent_request_set_permissions.dart';
import 'package:paperless_mobile/api/models/custom_field_instance_request.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_document_request.freezed.dart';
part 'patched_document_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedDocumentRequest with _$PatchedDocumentRequest {
  factory PatchedDocumentRequest({
    PatchedValue<int?>? correspondent,
    PatchedValue<int?>? documentType,
    PatchedValue<int?>? storagePath,
    PatchedValue<String?>? title,

    /// The raw, text-only data of the document. This field is primarily used for searching.
    PatchedValue<String?>? content,
    PatchedValue<List<int>?>? tags,
    PatchedValue<DateTime?>? created,
    @Deprecated('createdDate has been deprecated')
    PatchedValue<DateTime?>? createdDate,
    PatchedValue<DateTime?>? deletedAt,

    /// The position of this document in your physical document archive.
    // minimum: 0
    // maximum: 4294967295
    PatchedValue<int?>? archiveSerialNumber,
    PatchedValue<int?>? owner,
    CorrespondentRequestSetPermissions? setPermissions,
    PatchedValue<List<CustomFieldInstanceRequest>?>? customFields,
    @Default(false) bool? removeInboxTags,
  }) = _PatchedDocumentRequest;

  Map<String, dynamic> toJson() => convertPatchedValueJson(
    _$PatchedDocumentRequestToJson(this as _PatchedDocumentRequest),
  );
}
