import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/display_mode_enum.dart';
import 'package:paperless_mobile/api/models/saved_view_filter_rule_request.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_saved_view_request.freezed.dart';
part 'patched_saved_view_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedSavedViewRequest with _$PatchedSavedViewRequest {
  factory PatchedSavedViewRequest({
    Option<String?>? name,
    Option<bool?>? showOnDashboard,
    Option<bool?>? showInSidebar,
    Option<String?>? sortField,
    Option<bool?>? sortReverse,
    Option<List<SavedViewFilterRuleRequest>?>? filterRules,
    // minimum: 1
    // maximum: 2147483647
    Option<int?>? pageSize,
    Option<DisplayModeEnum?>? displayMode,
    Option<List<String>?>? displayFields,
    Option<int?>? owner,
  }) = _PatchedSavedViewRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedSavedViewRequestToJson(this as _PatchedSavedViewRequest),
  );
}
