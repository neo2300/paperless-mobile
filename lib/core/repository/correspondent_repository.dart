import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultCorrespondentsPageSize = 100000;

class CorrespondentRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const CorrespondentRepository(this._staticDataRepository, this._api);

  Future<Correspondent?> findAll({
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
      final response = await _api.getCorrespondentsApi().correspondentsList(
            fullPerms: fullPerms,
            id: id,
            idIn: idIn,
            nameIcontains: nameIcontains,
            nameIendswith: nameIendswith,
            nameIexact: nameIexact,
            nameIstartswith: nameIstartswith,
            ordering: ordering,
            page: page,
            pageSize: pageSize ?? defaultCorrespondentsPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final correspondent in response.data!.results) {
          _staticDataRepository.correspondents[correspondent.id] =
              correspondent;
        }
        _staticDataRepository.update(
          correspondents: Map.fromEntries(
            response.data!.results.map(
              (c) => MapEntry(c.id, c),
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

  Future<Correspondent?> find({
    required int id,
    bool? fullPerms,
  }) async {
    final response = await _api
        .getCorrespondentsApi()
        .correspondentsRetrieve(id: id, fullPerms: fullPerms);
    if (response.data != null) {
      final existing = _staticDataRepository.correspondents;
      _staticDataRepository.update(
        correspondents: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<Correspondent> create({
    required CorrespondentRequest correspondentRequest,
  }) async {
    final response = await _api.getCorrespondentsApi().correspondentsCreate(
          correspondentRequest: correspondentRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.correspondents;
      _staticDataRepository.update(
        correspondents: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<Correspondent> update({
    required int id,
    required CorrespondentRequest correspondentRequest,
  }) async {
    final response = await _api.getCorrespondentsApi().correspondentsUpdate(
          id: id,
          correspondentRequest: correspondentRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.correspondents;
      _staticDataRepository.update(
        correspondents: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getCorrespondentsApi().correspondentsDestroy(id: id);
    final existing = _staticDataRepository.correspondents;
    existing.remove(id);
    _staticDataRepository.update(correspondents: existing);
  }
}
