import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:paperless_mobile/api/models/workflow_action_email_request.dart';
import 'package:paperless_mobile/api/models/workflow_action_type_enum.dart';
import 'package:paperless_mobile/api/models/workflow_action_webhook_request.dart';
import 'package:paperless_mobile/api/utils/patched_value.dart';

part 'patched_workflow_action_request.freezed.dart';
part 'patched_workflow_action_request.g.dart';

@Freezed(toJson: true, fromJson: false)
abstract class PatchedWorkflowActionRequest
    with _$PatchedWorkflowActionRequest {
  factory PatchedWorkflowActionRequest({
    Option<int?>? id,
    // minimum: 0.0
    // maximum: 2.147483647E9
    Option<WorkflowActionTypeEnum?>? type,

    /// Assign a document title, can include some placeholders, see documentation.
    Option<String?>? assignTitle,
    Option<List<int>?>? assignTags,
    Option<int?>? assignCorrespondent,
    Option<int?>? assignDocumentType,
    Option<int?>? assignStoragePath,
    Option<int?>? assignOwner,
    Option<List<int>?>? assignViewUsers,
    Option<List<int>?>? assignViewGroups,
    Option<List<int>?>? assignChangeUsers,
    Option<List<int>?>? assignChangeGroups,
    Option<List<int>?>? assignCustomFields,

    /// Optional values to assign to the custom fields.
    Option<Object?>? assignCustomFieldsValues,
    Option<bool?>? removeAllTags,
    Option<List<int>?>? removeTags,
    Option<bool?>? removeAllCorrespondents,
    Option<List<int>?>? removeCorrespondents,
    Option<bool?>? removeAllDocumentTypes,
    Option<List<int>?>? removeDocumentTypes,
    Option<bool?>? removeAllStoragePaths,
    Option<List<int>?>? removeStoragePaths,
    Option<List<int>?>? removeCustomFields,
    Option<bool?>? removeAllCustomFields,
    Option<bool?>? removeAllOwners,
    Option<List<int>?>? removeOwners,
    Option<bool?>? removeAllPermissions,
    Option<List<int>?>? removeViewUsers,
    Option<List<int>?>? removeViewGroups,
    Option<List<int>?>? removeChangeUsers,
    Option<List<int>?>? removeChangeGroups,
    Option<WorkflowActionEmailRequest?>? email,
    Option<WorkflowActionWebhookRequest?>? webhook,
  }) = _PatchedWorkflowActionRequest;

  @override
  Map<String, dynamic> toJson() => processPatchedValueJson(
    _$PatchedWorkflowActionRequestToJson(this as _PatchedWorkflowActionRequest),
  );
}
