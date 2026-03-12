import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/workflow_action_request.dart';
import 'package:paperless_mobile/api/models/workflow_trigger_request.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_workflow_request.freezed.dart';
part 'patched_workflow_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedWorkflowRequest with _$PatchedWorkflowRequest {
  factory PatchedWorkflowRequest({
    Option<String?>? name,
    Option<int?>? order,
    Option<bool?>? enabled,
    Option<List<WorkflowTriggerRequest>?>? triggers,
    Option<List<WorkflowActionRequest>?>? actions,
  }) = _PatchedWorkflowRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedWorkflowRequestToJson(this as _PatchedWorkflowRequest),
  );
}
