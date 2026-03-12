import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/data_type_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_custom_field_request.freezed.dart';
part 'patched_custom_field_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedCustomFieldRequest with _$PatchedCustomFieldRequest {
  factory PatchedCustomFieldRequest({
    Option<String?>? name,
    Option<DataTypeEnum?>? dataType,

    /// Extra data for the custom field, such as select options
    Option<Object?>? extraData,
  }) = _PatchedCustomFieldRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedCustomFieldRequestToJson(this as _PatchedCustomFieldRequest),
  );
}
