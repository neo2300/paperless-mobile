import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultCustomFieldsPageSize = 100000;

class CustomFieldRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const CustomFieldRepository(this._staticDataRepository, this._api);

  Future<CustomField?> findAll({
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
      final response = await _api.getCustomFieldsApi().customFieldsList(
            id: id,
            idIn: idIn,
            nameIcontains: nameIcontains,
            nameIendswith: nameIendswith,
            nameIexact: nameIexact,
            nameIstartswith: nameIstartswith,
            ordering: ordering,
            page: page,
            pageSize: pageSize ?? defaultCustomFieldsPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final customField in response.data!.results) {
          _staticDataRepository.customFields[customField.id] = customField;
        }
        _staticDataRepository.update(
          customFields: Map.fromEntries(
            response.data!.results.map(
              (cf) => MapEntry(cf.id, cf),
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

  Future<CustomField?> find({
    required int id,
  }) async {
    final response =
        await _api.getCustomFieldsApi().customFieldsRetrieve(id: id);
    if (response.data != null) {
      final existing = _staticDataRepository.customFields;
      _staticDataRepository.update(
        customFields: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<CustomField> create({
    required CustomFieldRequest customFieldRequest,
  }) async {
    final response = await _api.getCustomFieldsApi().customFieldsCreate(
          customFieldRequest: customFieldRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.customFields;
      _staticDataRepository.update(
        customFields: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<CustomField> update({
    required int id,
    required CustomFieldRequest customFieldRequest,
  }) async {
    final response = await _api.getCustomFieldsApi().customFieldsUpdate(
          id: id,
          customFieldRequest: customFieldRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.customFields;
      _staticDataRepository.update(
        customFields: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getCustomFieldsApi().customFieldsDestroy(id: id);
    final existing = _staticDataRepository.customFields;
    existing.remove(id);
    _staticDataRepository.update(customFields: existing);
  }
}
