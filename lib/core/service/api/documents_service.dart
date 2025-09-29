import 'package:flutter/foundation.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

class DocumentsService extends ValueNotifier<List<Document>> {
  final PaperlessNgxApiV9 _api;

  DocumentsService(this._api) : super([]);

  Future<List<Document>> getAll() {
    return _api
        .getDocumentsApi()
        .documentsList()
        .then((response) => response.data?.results ?? []);
  }

  Future<Document?> getById(int id) {
    return _api
        .getDocumentsApi()
        .documentsRetrieve(id: id)
        .then((response) => response.data);
  }

  Future<Document> create(DocumentRequest request) async {
    throw UnimplementedError('Document creation is not supported.');
  }

  Future<Document> update(int id, DocumentRequest request) {
    return _api
        .getDocumentsApi()
        .documentsUpdate(id: id, documentRequest: request)
        .then((response) => response.data!);
  }

  Future<void> delete(int id) {
    return _api.getDocumentsApi().documentsDestroy(id: id);
  }
}
