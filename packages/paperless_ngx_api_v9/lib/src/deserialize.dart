import 'package:paperless_ngx_api_v9/src/model/acknowledge_tasks.dart';
import 'package:paperless_ngx_api_v9/src/model/acknowledge_tasks_request.dart';
import 'package:paperless_ngx_api_v9/src/model/actor.dart';
import 'package:paperless_ngx_api_v9/src/model/application_configuration.dart';
import 'package:paperless_ngx_api_v9/src/model/application_configuration_request.dart';
import 'package:paperless_ngx_api_v9/src/model/basic_user.dart';
import 'package:paperless_ngx_api_v9/src/model/basic_user_request.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_download.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_download_request.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_edit_documents_result.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_edit_objects_request.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_edit_request.dart';
import 'package:paperless_ngx_api_v9/src/model/bulk_edit_result.dart';
import 'package:paperless_ngx_api_v9/src/model/classifier.dart';
import 'package:paperless_ngx_api_v9/src/model/correspondent.dart';
import 'package:paperless_ngx_api_v9/src/model/correspondent_counts.dart';
import 'package:paperless_ngx_api_v9/src/model/correspondent_permissions.dart';
import 'package:paperless_ngx_api_v9/src/model/correspondent_permissions_view.dart';
import 'package:paperless_ngx_api_v9/src/model/correspondent_request.dart';
import 'package:paperless_ngx_api_v9/src/model/correspondent_request_set_permissions.dart';
import 'package:paperless_ngx_api_v9/src/model/custom_field.dart';
import 'package:paperless_ngx_api_v9/src/model/custom_field_counts.dart';
import 'package:paperless_ngx_api_v9/src/model/custom_field_instance.dart';
import 'package:paperless_ngx_api_v9/src/model/custom_field_instance_request.dart';
import 'package:paperless_ngx_api_v9/src/model/custom_field_request.dart';
import 'package:paperless_ngx_api_v9/src/model/database.dart';
import 'package:paperless_ngx_api_v9/src/model/document.dart';
import 'package:paperless_ngx_api_v9/src/model/document_list_request.dart';
import 'package:paperless_ngx_api_v9/src/model/document_request.dart';
import 'package:paperless_ngx_api_v9/src/model/document_share_links200_response_inner.dart';
import 'package:paperless_ngx_api_v9/src/model/document_type.dart';
import 'package:paperless_ngx_api_v9/src/model/document_type_counts.dart';
import 'package:paperless_ngx_api_v9/src/model/document_type_request.dart';
import 'package:paperless_ngx_api_v9/src/model/email_request_request.dart';
import 'package:paperless_ngx_api_v9/src/model/email_response.dart';
import 'package:paperless_ngx_api_v9/src/model/group.dart';
import 'package:paperless_ngx_api_v9/src/model/group_request.dart';
import 'package:paperless_ngx_api_v9/src/model/index.dart';
import 'package:paperless_ngx_api_v9/src/model/log_entry.dart';
import 'package:paperless_ngx_api_v9/src/model/mail_account.dart';
import 'package:paperless_ngx_api_v9/src/model/mail_account_process_response.dart';
import 'package:paperless_ngx_api_v9/src/model/mail_account_request.dart';
import 'package:paperless_ngx_api_v9/src/model/mail_account_test_response.dart';
import 'package:paperless_ngx_api_v9/src/model/mail_rule.dart';
import 'package:paperless_ngx_api_v9/src/model/mail_rule_request.dart';
import 'package:paperless_ngx_api_v9/src/model/metadata.dart';
import 'package:paperless_ngx_api_v9/src/model/migration_status.dart';
import 'package:paperless_ngx_api_v9/src/model/note_create_request_request.dart';
import 'package:paperless_ngx_api_v9/src/model/notes.dart';
import 'package:paperless_ngx_api_v9/src/model/notes_request.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_correspondent_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_custom_field_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_document_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_document_type_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_group_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_log_entry_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_mail_account_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_mail_rule_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_notes_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_saved_view_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_share_link_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_storage_path_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_tag_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_user_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_workflow_action_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_workflow_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paginated_workflow_trigger_list.dart';
import 'package:paperless_ngx_api_v9/src/model/paperless_auth_token.dart';
import 'package:paperless_ngx_api_v9/src/model/paperless_auth_token_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_application_configuration_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_correspondent_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_custom_field_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_document_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_document_type_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_group_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_mail_account_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_mail_rule_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_profile_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_saved_view_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_share_link_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_storage_path_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_tag_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_user_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_workflow_action_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_workflow_request.dart';
import 'package:paperless_ngx_api_v9/src/model/patched_workflow_trigger_request.dart';
import 'package:paperless_ngx_api_v9/src/model/profile.dart';
import 'package:paperless_ngx_api_v9/src/model/profile_disconnect_social_account_create_request.dart';
import 'package:paperless_ngx_api_v9/src/model/profile_totp_create_request.dart';
import 'package:paperless_ngx_api_v9/src/model/sanity_check.dart';
import 'package:paperless_ngx_api_v9/src/model/saved_view.dart';
import 'package:paperless_ngx_api_v9/src/model/saved_view_filter_rule.dart';
import 'package:paperless_ngx_api_v9/src/model/saved_view_filter_rule_request.dart';
import 'package:paperless_ngx_api_v9/src/model/saved_view_request.dart';
import 'package:paperless_ngx_api_v9/src/model/search_result.dart';
import 'package:paperless_ngx_api_v9/src/model/selection_data.dart';
import 'package:paperless_ngx_api_v9/src/model/share_link.dart';
import 'package:paperless_ngx_api_v9/src/model/share_link_request.dart';
import 'package:paperless_ngx_api_v9/src/model/social_account.dart';
import 'package:paperless_ngx_api_v9/src/model/social_account_request.dart';
import 'package:paperless_ngx_api_v9/src/model/storage.dart';
import 'package:paperless_ngx_api_v9/src/model/storage_path.dart';
import 'package:paperless_ngx_api_v9/src/model/storage_path_counts.dart';
import 'package:paperless_ngx_api_v9/src/model/storage_path_request.dart';
import 'package:paperless_ngx_api_v9/src/model/suggestions.dart';
import 'package:paperless_ngx_api_v9/src/model/system_status.dart';
import 'package:paperless_ngx_api_v9/src/model/tag.dart';
import 'package:paperless_ngx_api_v9/src/model/tag_counts.dart';
import 'package:paperless_ngx_api_v9/src/model/tag_request.dart';
import 'package:paperless_ngx_api_v9/src/model/tasks.dart';
import 'package:paperless_ngx_api_v9/src/model/tasks_view.dart';
import 'package:paperless_ngx_api_v9/src/model/tasks_view_request.dart';
import 'package:paperless_ngx_api_v9/src/model/trash_request.dart';
import 'package:paperless_ngx_api_v9/src/model/ui_settings_view.dart';
import 'package:paperless_ngx_api_v9/src/model/ui_settings_view_request.dart';
import 'package:paperless_ngx_api_v9/src/model/ui_settings_view_settings.dart';
import 'package:paperless_ngx_api_v9/src/model/ui_settings_view_settings_update_checking.dart';
import 'package:paperless_ngx_api_v9/src/model/ui_settings_view_user.dart';
import 'package:paperless_ngx_api_v9/src/model/user.dart';
import 'package:paperless_ngx_api_v9/src/model/user_request.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_action.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_action_email.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_action_email_request.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_action_request.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_action_webhook.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_action_webhook_request.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_request.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_trigger.dart';
import 'package:paperless_ngx_api_v9/src/model/workflow_trigger_request.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType,
    {bool growable = true}) {
  switch (targetType) {
    case 'String':
      return '$value' as ReturnType;
    case 'int':
      return (value is int ? value : int.parse('$value')) as ReturnType;
    case 'bool':
      if (value is bool) {
        return value as ReturnType;
      }
      final valueString = '$value'.toLowerCase();
      return (valueString == 'true' || valueString == '1') as ReturnType;
    case 'double':
      return (value is double ? value : double.parse('$value')) as ReturnType;
    case 'AccountTypeEnum':
    case 'AcknowledgeTasks':
      return AcknowledgeTasks.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'AcknowledgeTasksRequest':
      return AcknowledgeTasksRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'Actor':
      return Actor.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ApplicationConfiguration':
      return ApplicationConfiguration.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ApplicationConfigurationRequest':
      return ApplicationConfigurationRequest.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'AssignCorrespondentFromEnum':
    case 'AssignTitleFromEnum':
    case 'AttachmentTypeEnum':
    case 'BasicUser':
      return BasicUser.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'BasicUserRequest':
      return BasicUserRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'BulkDownload':
      return BulkDownload.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'BulkDownloadRequest':
      return BulkDownloadRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'BulkEditDocumentsResult':
      return BulkEditDocumentsResult.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'BulkEditObjectsRequest':
      return BulkEditObjectsRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'BulkEditRequest':
      return BulkEditRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'BulkEditResult':
      return BulkEditResult.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'Classifier':
      return Classifier.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ColorConversionStrategyEnum':
    case 'CompressionEnum':
    case 'ConsumptionScopeEnum':
    case 'ContentEnum':
    case 'Correspondent':
      return Correspondent.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CorrespondentCounts':
      return CorrespondentCounts.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CorrespondentPermissions':
      return CorrespondentPermissions.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CorrespondentPermissionsView':
      return CorrespondentPermissionsView.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'CorrespondentRequest':
      return CorrespondentRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CorrespondentRequestSetPermissions':
      return CorrespondentRequestSetPermissions.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'CustomField':
      return CustomField.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CustomFieldCounts':
      return CustomFieldCounts.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CustomFieldInstance':
      return CustomFieldInstance.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CustomFieldInstanceRequest':
      return CustomFieldInstanceRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CustomFieldRequest':
      return CustomFieldRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DataTypeEnum':
    case 'Database':
      return Database.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'DisplayModeEnum':
    case 'Document':
      return Document.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'DocumentListRequest':
      return DocumentListRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DocumentRequest':
      return DocumentRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DocumentShareLinks200ResponseInner':
      return DocumentShareLinks200ResponseInner.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'DocumentType':
      return DocumentType.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'DocumentTypeCounts':
      return DocumentTypeCounts.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DocumentTypeRequest':
      return DocumentTypeRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EmailRequestRequest':
      return EmailRequestRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'EmailResponse':
      return EmailResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'FileVersionEnum':
    case 'Group':
      return Group.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'GroupRequest':
      return GroupRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ImapSecurityEnum':
    case 'Index':
      return Index.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'LogEntry':
      return LogEntry.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MailAccount':
      return MailAccount.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MailAccountProcessResponse':
      return MailAccountProcessResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MailAccountRequest':
      return MailAccountRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MailAccountTestResponse':
      return MailAccountTestResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MailRule':
      return MailRule.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MailRuleActionEnum':
    case 'MailRuleRequest':
      return MailRuleRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MatchingAlgorithm':
    case 'Metadata':
      return Metadata.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MethodEnum':
    case 'MigrationStatus':
      return MigrationStatus.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ModeEnum':
    case 'NoteCreateRequestRequest':
      return NoteCreateRequestRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'Notes':
      return Notes.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'NotesRequest':
      return NotesRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ObjectTypeEnum':
    case 'OperationEnum':
    case 'OutputTypeEnum':
    case 'PaginatedCorrespondentList':
      return PaginatedCorrespondentList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedCustomFieldList':
      return PaginatedCustomFieldList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedDocumentList':
      return PaginatedDocumentList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedDocumentTypeList':
      return PaginatedDocumentTypeList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedGroupList':
      return PaginatedGroupList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedLogEntryList':
      return PaginatedLogEntryList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedMailAccountList':
      return PaginatedMailAccountList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedMailRuleList':
      return PaginatedMailRuleList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedNotesList':
      return PaginatedNotesList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedSavedViewList':
      return PaginatedSavedViewList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedShareLinkList':
      return PaginatedShareLinkList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedStoragePathList':
      return PaginatedStoragePathList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedTagList':
      return PaginatedTagList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedUserList':
      return PaginatedUserList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedWorkflowActionList':
      return PaginatedWorkflowActionList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedWorkflowList':
      return PaginatedWorkflowList.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaginatedWorkflowTriggerList':
      return PaginatedWorkflowTriggerList.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'PaperlessAuthToken':
      return PaperlessAuthToken.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PaperlessAuthTokenRequest':
      return PaperlessAuthTokenRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedApplicationConfigurationRequest':
      return PatchedApplicationConfigurationRequest.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'PatchedCorrespondentRequest':
      return PatchedCorrespondentRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedCustomFieldRequest':
      return PatchedCustomFieldRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedDocumentRequest':
      return PatchedDocumentRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedDocumentTypeRequest':
      return PatchedDocumentTypeRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedGroupRequest':
      return PatchedGroupRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedMailAccountRequest':
      return PatchedMailAccountRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedMailRuleRequest':
      return PatchedMailRuleRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedProfileRequest':
      return PatchedProfileRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedSavedViewRequest':
      return PatchedSavedViewRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedShareLinkRequest':
      return PatchedShareLinkRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedStoragePathRequest':
      return PatchedStoragePathRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedTagRequest':
      return PatchedTagRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedUserRequest':
      return PatchedUserRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedWorkflowActionRequest':
      return PatchedWorkflowActionRequest.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'PatchedWorkflowRequest':
      return PatchedWorkflowRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'PatchedWorkflowTriggerRequest':
      return PatchedWorkflowTriggerRequest.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'PdfLayoutEnum':
    case 'Profile':
      return Profile.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ProfileDisconnectSocialAccountCreateRequest':
      return ProfileDisconnectSocialAccountCreateRequest.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'ProfileTotpCreateRequest':
      return ProfileTotpCreateRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'RuleTypeEnum':
    case 'SanityCheck':
      return SanityCheck.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SavedView':
      return SavedView.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SavedViewFilterRule':
      return SavedViewFilterRule.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SavedViewFilterRuleRequest':
      return SavedViewFilterRuleRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SavedViewRequest':
      return SavedViewRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ScheduleDateFieldEnum':
    case 'SearchResult':
      return SearchResult.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SelectionData':
      return SelectionData.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ShareLink':
      return ShareLink.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ShareLinkRequest':
      return ShareLinkRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SkipArchiveFileEnum':
    case 'SocialAccount':
      return SocialAccount.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SocialAccountRequest':
      return SocialAccountRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SourcesEnum':
    case 'StatusEnum':
    case 'Storage':
      return Storage.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'StoragePath':
      return StoragePath.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'StoragePathCounts':
      return StoragePathCounts.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'StoragePathRequest':
      return StoragePathRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'Suggestions':
      return Suggestions.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SystemStatus':
      return SystemStatus.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Tag':
      return Tag.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'TagCounts':
      return TagCounts.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'TagRequest':
      return TagRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'TaskNameEnum':
    case 'Tasks':
      return Tasks.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'TasksView':
      return TasksView.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'TasksViewRequest':
      return TasksViewRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'TasksViewTypeEnum':
    case 'TrashActionEnum':
    case 'TrashRequest':
      return TrashRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'UiSettingsView':
      return UiSettingsView.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UiSettingsViewRequest':
      return UiSettingsViewRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UiSettingsViewSettings':
      return UiSettingsViewSettings.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UiSettingsViewSettingsUpdateChecking':
      return UiSettingsViewSettingsUpdateChecking.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'UiSettingsViewUser':
      return UiSettingsViewUser.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UnpaperCleanEnum':
    case 'User':
      return User.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'UserRequest':
      return UserRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Workflow':
      return Workflow.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'WorkflowAction':
      return WorkflowAction.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowActionEmail':
      return WorkflowActionEmail.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowActionEmailRequest':
      return WorkflowActionEmailRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowActionRequest':
      return WorkflowActionRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowActionTypeEnum':
    case 'WorkflowActionWebhook':
      return WorkflowActionWebhook.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowActionWebhookRequest':
      return WorkflowActionWebhookRequest.fromJson(
          value as Map<String, dynamic>) as ReturnType;
    case 'WorkflowRequest':
      return WorkflowRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowTrigger':
      return WorkflowTrigger.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowTriggerMatchingAlgorithmEnum':
    case 'WorkflowTriggerRequest':
      return WorkflowTriggerRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WorkflowTriggerTypeEnum':
    default:
      RegExpMatch? match;

      if (value is List && (match = _regList.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
            .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(
                v, targetType,
                growable: growable))
            .toList(growable: growable) as ReturnType;
      }
      if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
            .map<BaseType>((dynamic v) => deserialize<BaseType, BaseType>(
                v, targetType,
                growable: growable))
            .toSet() as ReturnType;
      }
      if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
        targetType = match![1]!.trim(); // ignore: parameter_assignments
        return Map<String, BaseType>.fromIterables(
          value.keys as Iterable<String>,
          value.values.map((dynamic v) => deserialize<BaseType, BaseType>(
              v, targetType,
              growable: growable)),
        ) as ReturnType;
      }
      break;
  }
  throw Exception('Cannot deserialize');
}
