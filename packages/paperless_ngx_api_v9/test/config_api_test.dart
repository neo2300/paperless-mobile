import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for ConfigApi
void main() {
  final instance = PaperlessNgxApiV9().getConfigApi();

  group(ConfigApi, () {
    //Future configDestroy(int id) async
    test('test configDestroy', () async {
      // TODO
    });

    // Get the application configuration
    //
    //Future<List<ApplicationConfiguration>> configList() async
    test('test configList', () async {
      // TODO
    });

    //Future<ApplicationConfiguration> configPartialUpdate(int id, { PatchedApplicationConfigurationRequest patchedApplicationConfigurationRequest }) async
    test('test configPartialUpdate', () async {
      // TODO
    });

    //Future<ApplicationConfiguration> configRetrieve(int id) async
    test('test configRetrieve', () async {
      // TODO
    });

    //Future<ApplicationConfiguration> configUpdate(int id, ApplicationConfigurationRequest applicationConfigurationRequest) async
    test('test configUpdate', () async {
      // TODO
    });
  });
}
