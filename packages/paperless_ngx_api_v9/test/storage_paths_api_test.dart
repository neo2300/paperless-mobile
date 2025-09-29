import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for StoragePathsApi
void main() {
  final instance = PaperlessNgxApiV9().getStoragePathsApi();

  group(StoragePathsApi, () {
    //Future<StoragePath> storagePathsCreate(StoragePathRequest storagePathRequest) async
    test('test storagePathsCreate', () async {
      // TODO
    });

    // When a storage path is deleted, see if documents using it require a rename/move
    //
    //Future storagePathsDestroy(int id) async
    test('test storagePathsDestroy', () async {
      // TODO
    });

    //Future<PaginatedStoragePathList> storagePathsList({ bool fullPerms, int id, List<int> idIn, String nameIcontains, String nameIendswith, String nameIexact, String nameIstartswith, String ordering, int page, int pageSize, String pathIcontains, String pathIendswith, String pathIexact, String pathIstartswith }) async
    test('test storagePathsList', () async {
      // TODO
    });

    //Future<StoragePath> storagePathsPartialUpdate(int id, { PatchedStoragePathRequest patchedStoragePathRequest }) async
    test('test storagePathsPartialUpdate', () async {
      // TODO
    });

    //Future<StoragePath> storagePathsRetrieve(int id, { bool fullPerms }) async
    test('test storagePathsRetrieve', () async {
      // TODO
    });

    // Test storage path against a document
    //
    //Future<StoragePath> storagePathsTestCreate(StoragePathRequest storagePathRequest) async
    test('test storagePathsTestCreate', () async {
      // TODO
    });

    //Future<StoragePath> storagePathsUpdate(int id, StoragePathRequest storagePathRequest) async
    test('test storagePathsUpdate', () async {
      // TODO
    });
  });
}
