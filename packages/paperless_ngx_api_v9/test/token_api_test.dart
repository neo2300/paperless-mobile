import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for TokenApi
void main() {
  final instance = PaperlessNgxApiV9().getTokenApi();

  group(TokenApi, () {
    //Future<PaperlessAuthToken> tokenCreate(String username, String password, { String code }) async
    test('test tokenCreate', () async {
      // TODO
    });
  });
}
