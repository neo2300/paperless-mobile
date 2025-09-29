import 'package:paperless_mobile/core/repository/remote_data_cache.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

const defaultUsersPageSize = 100000;

class UserRepository {
  final RemoteDataCache _staticDataRepository;
  final PaperlessNgxApiV9 _api;

  const UserRepository(this._staticDataRepository, this._api);

  Future<User?> findAll({
    String? ordering,
    int? page,
    int? pageSize,
  }) async {
    try {
      final response = await _api.getUsersApi().usersList(
            ordering: ordering,
            page: page,
            pageSize: pageSize ?? defaultUsersPageSize,
          );
      if (response.data?.results != null && response.data!.results.isNotEmpty) {
        for (final user in response.data!.results) {
          _staticDataRepository.users[user.id] = user;
        }
        _staticDataRepository.update(
          users: Map.fromEntries(
            response.data!.results.map(
              (u) => MapEntry(u.id, u),
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

  Future<User?> find({
    required int id,
  }) async {
    final response = await _api.getUsersApi().usersRetrieve(id: id);
    if (response.data != null) {
      final existing = _staticDataRepository.users;
      _staticDataRepository.update(
        users: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<User> create({
    required UserRequest userRequest,
  }) async {
    final response = await _api.getUsersApi().usersCreate(
          userRequest: userRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.users;
      _staticDataRepository.update(
        users: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<User> update({
    required int id,
    required UserRequest userRequest,
  }) async {
    final response = await _api.getUsersApi().usersUpdate(
          id: id,
          userRequest: userRequest,
        );
    if (response.data != null) {
      final existing = _staticDataRepository.users;
      _staticDataRepository.update(
        users: {...existing, response.data!.id: response.data!},
      );
    }
    return response.data!;
  }

  Future<void> delete({required int id}) async {
    await _api.getUsersApi().usersDestroy(id: id);
    final existing = _staticDataRepository.users;
    existing.remove(id);
    _staticDataRepository.update(users: existing);
  }
}
