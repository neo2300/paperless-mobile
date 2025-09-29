import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultTagsPageSize = 100000;

class TagRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const TagRepository(this._staticDataRepository, this._api);

  Future<Tag?> findAll({
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
      final response = await _api.getTagsApi().tagsList(
            fullPerms: fullPerms,
            id: id,
            idIn: idIn,
            nameIcontains: nameIcontains,
            nameIendswith: nameIendswith,
            nameIexact: nameIexact,
            nameIstartswith: nameIstartswith,
            ordering: ordering,
            page: page,
            pageSize: pageSize ?? defaultTagsPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final tag in response.data!.results) {
          _staticDataRepository.tags[tag.id] = tag;
        }
        _staticDataRepository.update(
          tags: Map.fromEntries(
            response.data!.results.map(
              (t) => MapEntry(t.id, t),
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

  Future<Tag?> find({
    required int id,
    bool? fullPerms,
  }) async {
    final response =
        await _api.getTagsApi().tagsRetrieve(id: id, fullPerms: fullPerms);
    if (response.data != null) {
      final existing = _staticDataRepository.tags;
      _staticDataRepository.update(
        tags: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<Tag> create({
    required TagRequest tagRequest,
  }) async {
    final response = await _api.getTagsApi().tagsCreate(
          tagRequest: tagRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.tags;
      _staticDataRepository.update(
        tags: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<Tag> update({
    required int id,
    required TagRequest tagRequest,
  }) async {
    final response = await _api.getTagsApi().tagsUpdate(
          id: id,
          tagRequest: tagRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.tags;
      _staticDataRepository.update(
        tags: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getTagsApi().tagsDestroy(id: id);
    final existing = _staticDataRepository.tags;
    existing.remove(id);
    _staticDataRepository.update(tags: existing);
  }
}
