import 'package:paperless_mobile/core/service/api/base_service.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

class TagsService implements BaseService<Tag, TagRequest> {
  final TagsApi _tagsApi;

  TagsService(this._tagsApi);

  @override
  Future<Tag> create(TagRequest request) {
    return _tagsApi
        .tagsCreate(tagRequest: request)
        .then((response) => response.data!);
  }

  @override
  Future<void> delete(int id) {
    return _tagsApi.tagsDestroy(id: id);
  }

  @override
  Future<List<Tag>> getAll() {
    return _tagsApi.tagsList().then((response) => response.data?.results ?? []);
  }

  @override
  Future<Tag?> getById(int id) {
    return _tagsApi.tagsRetrieve(id: id).then((response) => response.data);
  }

  @override
  Future<Tag> update(int id, TagRequest request) {
    return _tagsApi
        .tagsUpdate(id: id, tagRequest: request)
        .then((response) => response.data!);
  }
}
