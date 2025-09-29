import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for TagsApi
void main() {
  final instance = PaperlessNgxApiV9().getTagsApi();

  group(TagsApi, () {
    //Future<Tag> tagsCreate(TagRequest tagRequest) async
    test('test tagsCreate', () async {
      // TODO
    });

    //Future tagsDestroy(int id) async
    test('test tagsDestroy', () async {
      // TODO
    });

    //Future<PaginatedTagList> tagsList({ bool fullPerms, int id, List<int> idIn, String nameIcontains, String nameIendswith, String nameIexact, String nameIstartswith, String ordering, int page, int pageSize }) async
    test('test tagsList', () async {
      // TODO
    });

    //Future<Tag> tagsPartialUpdate(int id, { PatchedTagRequest patchedTagRequest }) async
    test('test tagsPartialUpdate', () async {
      // TODO
    });

    //Future<Tag> tagsRetrieve(int id, { bool fullPerms }) async
    test('test tagsRetrieve', () async {
      // TODO
    });

    //Future<Tag> tagsUpdate(int id, TagRequest tagRequest) async
    test('test tagsUpdate', () async {
      // TODO
    });
  });
}
