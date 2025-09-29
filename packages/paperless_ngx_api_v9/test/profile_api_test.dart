import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for ProfileApi
void main() {
  final instance = PaperlessNgxApiV9().getProfileApi();

  group(ProfileApi, () {
    // Disconnects a social account provider from the user account
    //
    //Future<int> profileDisconnectSocialAccountCreate({ ProfileDisconnectSocialAccountCreateRequest profileDisconnectSocialAccountCreateRequest }) async
    test('test profileDisconnectSocialAccountCreate', () async {
      // TODO
    });

    // Generates (or re-generates) an auth token, requires a logged in user unlike the default DRF endpoint
    //
    //Future<String> profileGenerateAuthTokenCreate() async
    test('test profileGenerateAuthTokenCreate', () async {
      // TODO
    });

    // User profile view, only available when logged in
    //
    //Future<Profile> profilePartialUpdate({ PatchedProfileRequest patchedProfileRequest }) async
    test('test profilePartialUpdate', () async {
      // TODO
    });

    // User profile view, only available when logged in
    //
    //Future<Profile> profileRetrieve() async
    test('test profileRetrieve', () async {
      // TODO
    });

    // List of social account providers
    //
    //Future<Map<String, Object>> profileSocialAccountProvidersRetrieve() async
    test('test profileSocialAccountProvidersRetrieve', () async {
      // TODO
    });

    // Validates a TOTP code and activates the TOTP authenticator
    //
    //Future<Map<String, Object>> profileTotpCreate({ ProfileTotpCreateRequest profileTotpCreateRequest }) async
    test('test profileTotpCreate', () async {
      // TODO
    });

    // Deactivates the TOTP authenticator
    //
    //Future<bool> profileTotpDestroy() async
    test('test profileTotpDestroy', () async {
      // TODO
    });

    // Generates a new TOTP secret and returns the URL and SVG
    //
    //Future<Map<String, Object>> profileTotpRetrieve() async
    test('test profileTotpRetrieve', () async {
      // TODO
    });
  });
}
