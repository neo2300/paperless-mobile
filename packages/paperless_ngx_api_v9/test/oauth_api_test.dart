import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for OauthApi
void main() {
  final instance = PaperlessNgxApiV9().getOauthApi();

  group(OauthApi, () {
    // Callback view for OAuth2 authentication
    //
    //Future oauthCallbackRetrieve() async
    test('test oauthCallbackRetrieve', () async {
      // TODO
    });
  });
}
