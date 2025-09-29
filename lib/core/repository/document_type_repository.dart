import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultDocumentTypesPageSize = 100000;

class DocumentTypeRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const DocumentTypeRepository(this._staticDataRepository, this._api);

  Future<DocumentType?> findAll({
    bool? fullPerms,
    int? id,
    List<int>? idIn,
    String? nameIcontains,
    String? nameIendswith,
    String? nameIexact,
    String? nameIstartswith,
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _api.getDocumentTypesApi().documentTypesList(
            fullPerms: fullPerms,
            id: id,
            idIn: idIn,
            nameIcontains: nameIcontains,
            nameIendswith: nameIendswith,
            nameIexact: nameIexact,
            nameIstartswith: nameIstartswith,
            ordering: ordering,
            page: page,
            pageSize: pageSize ?? defaultDocumentTypesPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final documentType in response.data!.results) {
          _staticDataRepository.documentTypes[documentType.id] = documentType;
        }
        _staticDataRepository.update(
          documentTypes: Map.fromEntries(
            response.data!.results.map(
              (dt) => MapEntry(dt.id, dt),
            ),
          ),
        );
        return response.data!.results.first;
      }
    } catch (e) {
      // Handle error appropriately, e.g., log it or rethrow
    }
    return null;
  }

  Future<DocumentType?> find({
    required int id,
    bool? fullPerms,
  }) async {
    final response = await _api
        .getDocumentTypesApi()
        .documentTypesRetrieve(id: id, fullPerms: fullPerms);
    if (response.data != null) {
      final existing = _staticDataRepository.documentTypes;
      _staticDataRepository.update(
        documentTypes: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<DocumentType> create({
    required DocumentTypeRequest documentTypeRequest,
  }) async {
    final response = await _api.getDocumentTypesApi().documentTypesCreate(
          documentTypeRequest: documentTypeRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.documentTypes;
      _staticDataRepository.update(
        documentTypes: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<DocumentType> update({
    required int id,
    required DocumentTypeRequest documentTypeRequest,
  }) async {
    final response = await _api.getDocumentTypesApi().documentTypesUpdate(
          id: id,
          documentTypeRequest: documentTypeRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.documentTypes;
      _staticDataRepository.update(
        documentTypes: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getDocumentTypesApi().documentTypesDestroy(id: id);
    final existing = _staticDataRepository.documentTypes;
    existing.remove(id);
    _staticDataRepository.update(documentTypes: existing);
  }
}
