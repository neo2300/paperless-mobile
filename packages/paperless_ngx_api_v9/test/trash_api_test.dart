import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for TrashApi
void main() {
  final instance = PaperlessNgxApiV9().getTrashApi();

  group(TrashApi, () {
    //Future trashCreate(TrashRequest trashRequest) async
    test('test trashCreate', () async {
      // TODO
    });

    //Future trashList({ int page, int pageSize }) async
    test('test trashList', () async {
      // TODO
    });
  });
}
