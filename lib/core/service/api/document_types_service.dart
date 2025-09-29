import 'package:paperless_mobile/core/service/api/base_service.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

class DocumentTypesService
    implements BaseService<DocumentType, DocumentTypeRequest> {
  final DocumentTypesApi _documentTypesApi;

  DocumentTypesService(this._documentTypesApi);

  @override
  Future<List<DocumentType>> getAll() {
    return _documentTypesApi
        .documentTypesList()
        .then((response) => response.data?.results ?? []);
  }

  @override
  Future<DocumentType?> getById(int id) {
    return _documentTypesApi
        .documentTypesRetrieve(id: id)
        .then((response) => response.data);
  }

  @override
  Future<DocumentType> create(DocumentTypeRequest request) {
    return _documentTypesApi
        .documentTypesCreate(documentTypeRequest: request)
        .then((response) => response.data!);
  }

  @override
  Future<DocumentType> update(int id, DocumentTypeRequest request) {
    return _documentTypesApi
        .documentTypesUpdate(id: id, documentTypeRequest: request)
        .then((response) => response.data!);
  }

  @override
  Future<void> delete(int id) {
    return _documentTypesApi.documentTypesDestroy(id: id);
  }
}
