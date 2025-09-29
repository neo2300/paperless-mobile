import 'package:paperless_mobile/core/service/api/base_service.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

class StoragePathsService
    implements BaseService<StoragePath, StoragePathRequest> {
  final StoragePathsApi _storagePathsApi;

  StoragePathsService(this._storagePathsApi);

  @override
  Future<List<StoragePath>> getAll() {
    return _storagePathsApi
        .storagePathsList()
        .then((response) => response.data?.results ?? []);
  }

  @override
  Future<StoragePath?> getById(int id) {
    return _storagePathsApi
        .storagePathsRetrieve(id: id)
        .then((response) => response.data);
  }

  @override
  Future<StoragePath> create(StoragePathRequest request) {
    return _storagePathsApi
        .storagePathsCreate(storagePathRequest: request)
        .then((response) => response.data!);
  }

  @override
  Future<StoragePath> update(int id, StoragePathRequest request) {
    return _storagePathsApi
        .storagePathsUpdate(id: id, storagePathRequest: request)
        .then((response) => response.data!);
  }

  @override
  Future<void> delete(int id) {
    return _storagePathsApi.storagePathsDestroy(id: id);
  }
}
