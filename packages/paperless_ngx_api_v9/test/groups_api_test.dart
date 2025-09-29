import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for GroupsApi
void main() {
  final instance = PaperlessNgxApiV9().getGroupsApi();

  group(GroupsApi, () {
    //Future<Group> groupsCreate(GroupRequest groupRequest) async
    test('test groupsCreate', () async {
      // TODO
    });

    //Future groupsDestroy(int id) async
    test('test groupsDestroy', () async {
      // TODO
    });

    //Future<PaginatedGroupList> groupsList({ String nameIcontains, String nameIendswith, String nameIexact, String nameIstartswith, String ordering, int page, int pageSize }) async
    test('test groupsList', () async {
      // TODO
    });

    //Future<Group> groupsPartialUpdate(int id, { PatchedGroupRequest patchedGroupRequest }) async
    test('test groupsPartialUpdate', () async {
      // TODO
    });

    //Future<Group> groupsRetrieve(int id) async
    test('test groupsRetrieve', () async {
      // TODO
    });

    //Future<Group> groupsUpdate(int id, GroupRequest groupRequest) async
    test('test groupsUpdate', () async {
      // TODO
    });
  });
}
