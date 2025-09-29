import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for UiSettingsApi
void main() {
  final instance = PaperlessNgxApiV9().getUiSettingsApi();

  group(UiSettingsApi, () {
    //Future<UiSettingsView> uiSettingsCreate({ UiSettingsViewRequest uiSettingsViewRequest }) async
    test('test uiSettingsCreate', () async {
      // TODO
    });

    //Future<UiSettingsView> uiSettingsRetrieve() async
    test('test uiSettingsRetrieve', () async {
      // TODO
    });
  });
}
