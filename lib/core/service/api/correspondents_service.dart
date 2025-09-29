import 'package:paperless_mobile/core/service/api/base_service.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

class CorrespondentsService
    implements BaseService<Correspondent, CorrespondentRequest> {
  final CorrespondentsApi _tagsApi;

  CorrespondentsService(this._tagsApi);

  @override
  Future<Correspondent> create(CorrespondentRequest request) {
    return _tagsApi
        .correspondentsCreate(correspondentRequest: request)
        .then((response) => response.data!);
  }

  @override
  Future<void> delete(int id) {
    return _tagsApi.correspondentsDestroy(id: id);
  }

  @override
  Future<List<Correspondent>> getAll() {
    return _tagsApi
        .correspondentsList()
        .then((response) => response.data?.results ?? []);
  }

  @override
  Future<Correspondent?> getById(int id) {
    return _tagsApi
        .correspondentsRetrieve(id: id)
        .then((response) => response.data);
  }

  @override
  Future<Correspondent> update(int id, CorrespondentRequest request) {
    return _tagsApi
        .correspondentsUpdate(id: id, correspondentRequest: request)
        .then((response) => response.data!);
  }
}
