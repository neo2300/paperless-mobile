import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for CustomFieldsApi
void main() {
  final instance = PaperlessNgxApiV9().getCustomFieldsApi();

  group(CustomFieldsApi, () {
    //Future<CustomField> customFieldsCreate(CustomFieldRequest customFieldRequest) async
    test('test customFieldsCreate', () async {
      // TODO
    });

    //Future customFieldsDestroy(int id) async
    test('test customFieldsDestroy', () async {
      // TODO
    });

    //Future<PaginatedCustomFieldList> customFieldsList({ int id, List<int> idIn, String nameIcontains, String nameIendswith, String nameIexact, String nameIstartswith, String ordering, int page, int pageSize }) async
    test('test customFieldsList', () async {
      // TODO
    });

    //Future<CustomField> customFieldsPartialUpdate(int id, { PatchedCustomFieldRequest patchedCustomFieldRequest }) async
    test('test customFieldsPartialUpdate', () async {
      // TODO
    });

    //Future<CustomField> customFieldsRetrieve(int id) async
    test('test customFieldsRetrieve', () async {
      // TODO
    });

    //Future<CustomField> customFieldsUpdate(int id, CustomFieldRequest customFieldRequest) async
    test('test customFieldsUpdate', () async {
      // TODO
    });
  });
}
