import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultPageSize = 100000;

///
/// A simple lookup cache for data which is always completely queried anyway.
///
class RemoteDataCache extends ChangeNotifier {
  final PaperlessNgxApiV9 _api;

  // Internal caches
  final Map<int, DocumentType> _documentTypes = {};
  final Map<int, Correspondent> _correspondents = {};
  final Map<int, Tag> _tags = {};
  final Map<int, CustomField> _customFields = {};
  final Map<int, SavedView> _savedViews = {};
  final Map<int, Group> _groups = {};
  final Map<int, User> _users = {};
  final Map<int, ShareLink> _shareLinks = {};

  bool isInitialized = false;
  bool loading = false;

  RemoteDataCache(this._api);

  Map<int, DocumentType> get documentTypes => _documentTypes;
  Map<int, Correspondent> get correspondents => _correspondents;
  Map<int, Tag> get tags => _tags;
  Map<int, CustomField> get customFields => _customFields;
  Map<int, SavedView> get savedViews => _savedViews;
  Map<int, Group> get groups => _groups;
  Map<int, User> get users => _users;
  Map<int, ShareLink> get shareLinks => _shareLinks;

  DocumentType? getDocumentType(int id) => _documentTypes[id];
  Correspondent? getCorrespondent(int id) => _correspondents[id];
  Tag? getTag(int id) => _tags[id];
  CustomField? getCustomField(int id) => _customFields[id];

  // Fetch and cache all static data (call this on app start or login)
  Future<void> initialize() async {
    loading = true;
    notifyListeners();
    final [
      docTypesResponse as Response<PaginatedDocumentTypeList>,
      correspondentsResponse as Response<PaginatedCorrespondentList>,
      tagsResponse as Response<PaginatedTagList>,
      customFieldsResponse as Response<PaginatedCustomFieldList>,
      savedViewsResponse as Response<PaginatedSavedViewList>,
      groupsResponse as Response<PaginatedGroupList>,
      usersResponse as Response<PaginatedUserList>,
      shareLinksResponse as Response<PaginatedShareLinkList>,
    ] = await Future.wait([
      _api.getDocumentTypesApi().documentTypesList(pageSize: defaultPageSize),
      _api.getCorrespondentsApi().correspondentsList(pageSize: defaultPageSize),
      _api.getTagsApi().tagsList(pageSize: defaultPageSize),
      _api.getCustomFieldsApi().customFieldsList(pageSize: defaultPageSize),
      _api.getSavedViewsApi().savedViewsList(pageSize: defaultPageSize),
      _api.getGroupsApi().groupsList(pageSize: defaultPageSize),
      _api.getUsersApi().usersList(pageSize: defaultPageSize),
      _api.getShareLinksApi().shareLinksList(pageSize: defaultPageSize),
    ]);
    _documentTypes
      ..clear()
      ..addEntries(
          (docTypesResponse.data?.results ?? []).map((t) => MapEntry(t.id, t)));
    _correspondents
      ..clear()
      ..addEntries((correspondentsResponse.data?.results ?? [])
          .map((c) => MapEntry(c.id, c)));
    _tags
      ..clear()
      ..addEntries(
          (tagsResponse.data?.results ?? []).map((t) => MapEntry(t.id, t)));
    _customFields
      ..clear()
      ..addEntries((customFieldsResponse.data?.results ?? [])
          .map((cf) => MapEntry(cf.id, cf)));
    _savedViews
      ..clear()
      ..addEntries((savedViewsResponse.data?.results ?? [])
          .map((sv) => MapEntry(sv.id!, sv)));
    _groups
      ..clear()
      ..addEntries(
          (groupsResponse.data?.results ?? []).map((g) => MapEntry(g.id, g)));
    _users
      ..clear()
      ..addEntries(
          (usersResponse.data?.results ?? []).map((u) => MapEntry(u.id, u)));
    _shareLinks
      ..clear()
      ..addEntries((shareLinksResponse.data?.results ?? [])
          .map((sl) => MapEntry(sl.id, sl)));

    isInitialized = true;
    loading = false;

    notifyListeners();
  }

  ///
  /// Updates the cache with the provided values and notifies listeners.
  ///
  Future<void> update({
    Map<int, DocumentType>? documentTypes,
    Map<int, Correspondent>? correspondents,
    Map<int, Tag>? tags,
    Map<int, CustomField>? customFields,
    Map<int, SavedView>? savedViews,
    Map<int, Group>? groups,
    Map<int, User>? users,
    Map<int, ShareLink>? shareLinks,
  }) async {
    if (documentTypes != null) {
      _documentTypes
        ..clear()
        ..addAll(documentTypes);
    }
    if (correspondents != null) {
      _correspondents
        ..clear()
        ..addAll(correspondents);
    }
    if (tags != null) {
      _tags
        ..clear()
        ..addAll(tags);
    }
    if (customFields != null) {
      _customFields
        ..clear()
        ..addAll(customFields);
    }
    if (savedViews != null) {
      _savedViews
        ..clear()
        ..addAll(savedViews);
    }
    if (groups != null) {
      _groups
        ..clear()
        ..addAll(groups);
    }
    if (users != null) {
      _users
        ..clear()
        ..addAll(users);
    }
    if (shareLinks != null) {
      _shareLinks
        ..clear()
        ..addAll(shareLinks);
    }
    notifyListeners();
  }

  Future<void> reloadDocumentTypes() async {
    final response = await _api
        .getDocumentTypesApi()
        .documentTypesList(pageSize: defaultPageSize);
    _documentTypes
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((t) => MapEntry(t.id, t)));
    notifyListeners();
  }

  Future<void> reloadCorrespondents() async {
    final response = await _api
        .getCorrespondentsApi()
        .correspondentsList(pageSize: defaultPageSize);
    _correspondents
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((c) => MapEntry(c.id, c)));
    notifyListeners();
  }

  Future<void> reloadTags() async {
    final response =
        await _api.getTagsApi().tagsList(pageSize: defaultPageSize);
    _tags
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((t) => MapEntry(t.id, t)));
    notifyListeners();
  }

  Future<void> reloadCustomFields() async {
    final response = await _api
        .getCustomFieldsApi()
        .customFieldsList(pageSize: defaultPageSize);
    _customFields
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((cf) => MapEntry(cf.id, cf)));
    notifyListeners();
  }

  Future<void> reloadSavedViews() async {
    final response =
        await _api.getSavedViewsApi().savedViewsList(pageSize: defaultPageSize);
    _savedViews
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((sv) => MapEntry(sv.id!, sv)));
    notifyListeners();
  }

  Future<void> reloadGroups() async {
    final response =
        await _api.getGroupsApi().groupsList(pageSize: defaultPageSize);
    _groups
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((g) => MapEntry(g.id, g)));
    notifyListeners();
  }

  Future<void> reloadUsers() async {
    final response =
        await _api.getUsersApi().usersList(pageSize: defaultPageSize);
    _users
      ..clear()
      ..addEntries(
          (response.data?.results ?? []).map((u) => MapEntry(u.id, u)));
    notifyListeners();
  }

  Future<void> reload() async {
    await initialize();
  }
}
