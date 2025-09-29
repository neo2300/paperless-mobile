import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for BulkEditObjectsApi
void main() {
  final instance = PaperlessNgxApiV9().getBulkEditObjectsApi();

  group(BulkEditObjectsApi, () {
    // Perform a bulk edit operation on a list of objects
    //
    //Future<BulkEditResult> bulkEditObjects(BulkEditObjectsRequest bulkEditObjectsRequest) async
    test('test bulkEditObjects', () async {
      // TODO
    });
  });
}
