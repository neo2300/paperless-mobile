import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultGroupsPageSize = 100000;

class GroupRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const GroupRepository(this._staticDataRepository, this._api);

  Future<Group?> findAll({
    String? nameIcontains,
    String? nameIendswith,
    String? nameIexact,
    String? nameIstartswith,
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _api.getGroupsApi().groupsList(
            nameIcontains: nameIcontains,
            nameIendswith: nameIendswith,
            nameIexact: nameIexact,
            nameIstartswith: nameIstartswith,
            ordering: ordering,
            page: page,
            pageSize: pageSize ?? defaultGroupsPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final group in response.data!.results) {
          _staticDataRepository.groups[group.id] = group;
        }
        _staticDataRepository.update(
          groups: Map.fromEntries(
            response.data!.results.map(
              (g) => MapEntry(g.id, g),
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

  Future<Group?> find({
    required int id,
  }) async {
    final response = await _api.getGroupsApi().groupsRetrieve(id: id);
    if (response.data != null) {
      final existing = _staticDataRepository.groups;
      _staticDataRepository.update(
        groups: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<Group> create({
    required GroupRequest groupRequest,
  }) async {
    final response = await _api.getGroupsApi().groupsCreate(
          groupRequest: groupRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.groups;
      _staticDataRepository.update(
        groups: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<Group> update({
    required int id,
    required GroupRequest groupRequest,
  }) async {
    final response = await _api.getGroupsApi().groupsUpdate(
          id: id,
          groupRequest: groupRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.groups;
      _staticDataRepository.update(
        groups: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getGroupsApi().groupsDestroy(id: id);
    final existing = _staticDataRepository.groups;
    existing.remove(id);
    _staticDataRepository.update(groups: existing);
  }
}
