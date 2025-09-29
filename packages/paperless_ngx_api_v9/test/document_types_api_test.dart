import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for DocumentTypesApi
void main() {
  final instance = PaperlessNgxApiV9().getDocumentTypesApi();

  group(DocumentTypesApi, () {
    //Future<DocumentType> documentTypesCreate(DocumentTypeRequest documentTypeRequest) async
    test('test documentTypesCreate', () async {
      // TODO
    });

    //Future documentTypesDestroy(int id) async
    test('test documentTypesDestroy', () async {
      // TODO
    });

    //Future<PaginatedDocumentTypeList> documentTypesList({ bool fullPerms, int id, List<int> idIn, String nameIcontains, String nameIendswith, String nameIexact, String nameIstartswith, String ordering, int page, int pageSize }) async
    test('test documentTypesList', () async {
      // TODO
    });

    //Future<DocumentType> documentTypesPartialUpdate(int id, { PatchedDocumentTypeRequest patchedDocumentTypeRequest }) async
    test('test documentTypesPartialUpdate', () async {
      // TODO
    });

    //Future<DocumentType> documentTypesRetrieve(int id, { bool fullPerms }) async
    test('test documentTypesRetrieve', () async {
      // TODO
    });

    //Future<DocumentType> documentTypesUpdate(int id, DocumentTypeRequest documentTypeRequest) async
    test('test documentTypesUpdate', () async {
      // TODO
    });
  });
}
