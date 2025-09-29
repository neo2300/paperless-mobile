import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for RemoteVersionApi
void main() {
  final instance = PaperlessNgxApiV9().getRemoteVersionApi();

  group(RemoteVersionApi, () {
    // Get the current version of the Paperless-NGX server
    //
    //Future<Map<String, Object>> remoteVersionRetrieve() async
    test('test remoteVersionRetrieve', () async {
      // TODO
    });
  });
}
