import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for CorrespondentsApi
void main() {
  final instance = PaperlessNgxApiV9().getCorrespondentsApi();

  group(CorrespondentsApi, () {
    //Future<Correspondent> correspondentsCreate(CorrespondentRequest correspondentRequest) async
    test('test correspondentsCreate', () async {
      // TODO
    });

    //Future correspondentsDestroy(int id) async
    test('test correspondentsDestroy', () async {
      // TODO
    });

    //Future<PaginatedCorrespondentList> correspondentsList({ bool fullPerms, int id, List<int> idIn, String nameIcontains, String nameIendswith, String nameIexact, String nameIstartswith, String ordering, int page, int pageSize }) async
    test('test correspondentsList', () async {
      // TODO
    });

    //Future<Correspondent> correspondentsPartialUpdate(int id, { PatchedCorrespondentRequest patchedCorrespondentRequest }) async
    test('test correspondentsPartialUpdate', () async {
      // TODO
    });

    //Future<Correspondent> correspondentsRetrieve(int id, { bool fullPerms }) async
    test('test correspondentsRetrieve', () async {
      // TODO
    });

    //Future<Correspondent> correspondentsUpdate(int id, CorrespondentRequest correspondentRequest) async
    test('test correspondentsUpdate', () async {
      // TODO
    });
  });
}
