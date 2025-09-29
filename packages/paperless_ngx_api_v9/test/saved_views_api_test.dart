import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for SavedViewsApi
void main() {
  final instance = PaperlessNgxApiV9().getSavedViewsApi();

  group(SavedViewsApi, () {
    //Future<SavedView> savedViewsCreate(SavedViewRequest savedViewRequest) async
    test('test savedViewsCreate', () async {
      // TODO
    });

    //Future savedViewsDestroy(int id) async
    test('test savedViewsDestroy', () async {
      // TODO
    });

    //Future<PaginatedSavedViewList> savedViewsList({ int page, int pageSize }) async
    test('test savedViewsList', () async {
      // TODO
    });

    //Future<SavedView> savedViewsPartialUpdate(int id, { PatchedSavedViewRequest patchedSavedViewRequest }) async
    test('test savedViewsPartialUpdate', () async {
      // TODO
    });

    //Future<SavedView> savedViewsRetrieve(int id) async
    test('test savedViewsRetrieve', () async {
      // TODO
    });

    //Future<SavedView> savedViewsUpdate(int id, SavedViewRequest savedViewRequest) async
    test('test savedViewsUpdate', () async {
      // TODO
    });
  });
}
