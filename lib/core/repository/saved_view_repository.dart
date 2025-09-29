import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultSavedViewsPageSize = 100000;

class SavedViewRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const SavedViewRepository(this._staticDataRepository, this._api);

  Future<SavedView?> findAll({
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _api.getSavedViewsApi().savedViewsList(
            page: page,
            pageSize: pageSize ?? defaultSavedViewsPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final savedView in response.data!.results) {
          _staticDataRepository.savedViews[savedView.id] = savedView;
        }
        _staticDataRepository.update(
          savedViews: Map.fromEntries(
            response.data!.results.map(
              (sv) => MapEntry(sv.id, sv),
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

  Future<SavedView?> find({
    required int id,
  }) async {
    final response = await _api.getSavedViewsApi().savedViewsRetrieve(id: id);
    if (response.data != null) {
      final existing = _staticDataRepository.savedViews;
      _staticDataRepository.update(
        savedViews: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<SavedView> create({
    required SavedViewRequest savedViewRequest,
  }) async {
    final response = await _api.getSavedViewsApi().savedViewsCreate(
          savedViewRequest: savedViewRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.savedViews;
      _staticDataRepository.update(
        savedViews: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<SavedView> update({
    required int id,
    required SavedViewRequest savedViewRequest,
  }) async {
    final response = await _api.getSavedViewsApi().savedViewsUpdate(
          id: id,
          savedViewRequest: savedViewRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.savedViews;
      _staticDataRepository.update(
        savedViews: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getSavedViewsApi().savedViewsDestroy(id: id);
    final existing = _staticDataRepository.savedViews;
    existing.remove(id);
    _staticDataRepository.update(savedViews: existing);
  }
}
