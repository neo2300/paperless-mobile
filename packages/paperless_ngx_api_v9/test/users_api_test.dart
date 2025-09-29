import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for UsersApi
void main() {
  final instance = PaperlessNgxApiV9().getUsersApi();

  group(UsersApi, () {
    //Future<User> usersCreate(UserRequest userRequest) async
    test('test usersCreate', () async {
      // TODO
    });

    //Future<bool> usersDeactivateTotpCreate(int id) async
    test('test usersDeactivateTotpCreate', () async {
      // TODO
    });

    //Future usersDestroy(int id) async
    test('test usersDestroy', () async {
      // TODO
    });

    //Future<PaginatedUserList> usersList({ String ordering, int page, int pageSize, String usernameIcontains, String usernameIendswith, String usernameIexact, String usernameIstartswith }) async
    test('test usersList', () async {
      // TODO
    });

    //Future<User> usersPartialUpdate(int id, { PatchedUserRequest patchedUserRequest }) async
    test('test usersPartialUpdate', () async {
      // TODO
    });

    //Future<User> usersRetrieve(int id) async
    test('test usersRetrieve', () async {
      // TODO
    });

    //Future<User> usersUpdate(int id, UserRequest userRequest) async
    test('test usersUpdate', () async {
      // TODO
    });
  });
}
