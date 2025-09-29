//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:paperless_ngx_api_v9/src/auth/api_key_auth.dart';
import 'package:paperless_ngx_api_v9/src/auth/basic_auth.dart';
import 'package:paperless_ngx_api_v9/src/auth/bearer_auth.dart';
import 'package:paperless_ngx_api_v9/src/auth/oauth.dart';
import 'package:paperless_ngx_api_v9/src/api/bulk_edit_objects_api.dart';
import 'package:paperless_ngx_api_v9/src/api/config_api.dart';
import 'package:paperless_ngx_api_v9/src/api/correspondents_api.dart';
import 'package:paperless_ngx_api_v9/src/api/custom_fields_api.dart';
import 'package:paperless_ngx_api_v9/src/api/document_types_api.dart';
import 'package:paperless_ngx_api_v9/src/api/documents_api.dart';
import 'package:paperless_ngx_api_v9/src/api/groups_api.dart';
import 'package:paperless_ngx_api_v9/src/api/logs_api.dart';
import 'package:paperless_ngx_api_v9/src/api/mail_accounts_api.dart';
import 'package:paperless_ngx_api_v9/src/api/mail_rules_api.dart';
import 'package:paperless_ngx_api_v9/src/api/oauth_api.dart';
import 'package:paperless_ngx_api_v9/src/api/profile_api.dart';
import 'package:paperless_ngx_api_v9/src/api/remote_version_api.dart';
import 'package:paperless_ngx_api_v9/src/api/saved_views_api.dart';
import 'package:paperless_ngx_api_v9/src/api/search_api.dart';
import 'package:paperless_ngx_api_v9/src/api/share_links_api.dart';
import 'package:paperless_ngx_api_v9/src/api/statistics_api.dart';
import 'package:paperless_ngx_api_v9/src/api/status_api.dart';
import 'package:paperless_ngx_api_v9/src/api/storage_paths_api.dart';
import 'package:paperless_ngx_api_v9/src/api/tags_api.dart';
import 'package:paperless_ngx_api_v9/src/api/tasks_api.dart';
import 'package:paperless_ngx_api_v9/src/api/token_api.dart';
import 'package:paperless_ngx_api_v9/src/api/trash_api.dart';
import 'package:paperless_ngx_api_v9/src/api/ui_settings_api.dart';
import 'package:paperless_ngx_api_v9/src/api/users_api.dart';
import 'package:paperless_ngx_api_v9/src/api/workflow_actions_api.dart';
import 'package:paperless_ngx_api_v9/src/api/workflow_triggers_api.dart';
import 'package:paperless_ngx_api_v9/src/api/workflows_api.dart';

class PaperlessNgxApiV9 {
  static const String basePath = r'http://localhost';

  final Dio dio;
  PaperlessNgxApiV9({
    Dio? dio,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  }) : this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor)
              as OAuthInterceptor)
          .tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor)
              as BearerAuthInterceptor)
          .tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor)
              as BasicAuthInterceptor)
          .authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this
                  .dio
                  .interceptors
                  .firstWhere((element) => element is ApiKeyAuthInterceptor)
              as ApiKeyAuthInterceptor)
          .apiKeys[name] = apiKey;
    }
  }

  /// Get BulkEditObjectsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  BulkEditObjectsApi getBulkEditObjectsApi() {
    return BulkEditObjectsApi(dio);
  }

  /// Get ConfigApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ConfigApi getConfigApi() {
    return ConfigApi(dio);
  }

  /// Get CorrespondentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CorrespondentsApi getCorrespondentsApi() {
    return CorrespondentsApi(dio);
  }

  /// Get CustomFieldsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  CustomFieldsApi getCustomFieldsApi() {
    return CustomFieldsApi(dio);
  }

  /// Get DocumentTypesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DocumentTypesApi getDocumentTypesApi() {
    return DocumentTypesApi(dio);
  }

  /// Get DocumentsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  DocumentsApi getDocumentsApi() {
    return DocumentsApi(dio);
  }

  /// Get GroupsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  GroupsApi getGroupsApi() {
    return GroupsApi(dio);
  }

  /// Get LogsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  LogsApi getLogsApi() {
    return LogsApi(dio);
  }

  /// Get MailAccountsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MailAccountsApi getMailAccountsApi() {
    return MailAccountsApi(dio);
  }

  /// Get MailRulesApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  MailRulesApi getMailRulesApi() {
    return MailRulesApi(dio);
  }

  /// Get OauthApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  OauthApi getOauthApi() {
    return OauthApi(dio);
  }

  /// Get ProfileApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ProfileApi getProfileApi() {
    return ProfileApi(dio);
  }

  /// Get RemoteVersionApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  RemoteVersionApi getRemoteVersionApi() {
    return RemoteVersionApi(dio);
  }

  /// Get SavedViewsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SavedViewsApi getSavedViewsApi() {
    return SavedViewsApi(dio);
  }

  /// Get SearchApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  SearchApi getSearchApi() {
    return SearchApi(dio);
  }

  /// Get ShareLinksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  ShareLinksApi getShareLinksApi() {
    return ShareLinksApi(dio);
  }

  /// Get StatisticsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StatisticsApi getStatisticsApi() {
    return StatisticsApi(dio);
  }

  /// Get StatusApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StatusApi getStatusApi() {
    return StatusApi(dio);
  }

  /// Get StoragePathsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  StoragePathsApi getStoragePathsApi() {
    return StoragePathsApi(dio);
  }

  /// Get TagsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TagsApi getTagsApi() {
    return TagsApi(dio);
  }

  /// Get TasksApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TasksApi getTasksApi() {
    return TasksApi(dio);
  }

  /// Get TokenApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TokenApi getTokenApi() {
    return TokenApi(dio);
  }

  /// Get TrashApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  TrashApi getTrashApi() {
    return TrashApi(dio);
  }

  /// Get UiSettingsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UiSettingsApi getUiSettingsApi() {
    return UiSettingsApi(dio);
  }

  /// Get UsersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  UsersApi getUsersApi() {
    return UsersApi(dio);
  }

  /// Get WorkflowActionsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WorkflowActionsApi getWorkflowActionsApi() {
    return WorkflowActionsApi(dio);
  }

  /// Get WorkflowTriggersApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WorkflowTriggersApi getWorkflowTriggersApi() {
    return WorkflowTriggersApi(dio);
  }

  /// Get WorkflowsApi instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  WorkflowsApi getWorkflowsApi() {
    return WorkflowsApi(dio);
  }
}
