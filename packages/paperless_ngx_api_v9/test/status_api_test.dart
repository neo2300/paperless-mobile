import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for StatusApi
void main() {
  final instance = PaperlessNgxApiV9().getStatusApi();

  group(StatusApi, () {
    // Get the current system status of the Paperless-NGX server
    //
    //Future<SystemStatus> statusRetrieve() async
    test('test statusRetrieve', () async {
      // TODO
    });
  });
}
