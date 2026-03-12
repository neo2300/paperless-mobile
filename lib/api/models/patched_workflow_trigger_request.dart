import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/schedule_date_field_enum.dart';
import 'package:paperless_mobile/api/models/sources_enum.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_matching_algorithm_enum.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_type_enum.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_workflow_trigger_request.freezed.dart';
part 'patched_workflow_trigger_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedWorkflowTriggerRequest
    with _$PatchedWorkflowTriggerRequest {
  factory PatchedWorkflowTriggerRequest({
    Option<int?>? id,
    Option<List<SourcesEnum>?>? sources,
    Option<WorkflowTriggerTypeEnum?>? type,

    /// Only consume documents with a path that matches this if specified. Wildcards specified as * are allowed. Case insensitive.
    Option<String?>? filterPath,

    /// Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
    Option<String?>? filterFilename,
    Option<int?>? filterMailrule,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<WorkflowTriggerMatchingAlgorithmEnum?>? matchingAlgorithm,
    Option<String?>? match,
    Option<bool?>? isInsensitive,
    Option<List<int>?>? filterHasTags,
    Option<int?>? filterHasCorrespondent,
    Option<int?>? filterHasDocumentType,

    /// The number of days to offset the schedule trigger by.
    // minimum: -2147483648
    // maximum: 2147483647
    Option<int?>? scheduleOffsetDays,

    /// If the schedule should be recurring.
    Option<bool?>? scheduleIsRecurring,

    /// The number of days between recurring schedule triggers.
    // minimum: 1
    // maximum: 2147483647
    Option<int?>? scheduleRecurringIntervalDays,

    /// The field to check for a schedule trigger.  * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
    Option<ScheduleDateFieldEnum?>? scheduleDateField,
    Option<int?>? scheduleDateCustomField,
  }) = _PatchedWorkflowTriggerRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedWorkflowTriggerRequestToJson(
      this as _PatchedWorkflowTriggerRequest,
    ),
  );
}
