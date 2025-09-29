import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for LogsApi
void main() {
  final instance = PaperlessNgxApiV9().getLogsApi();

  group(LogsApi, () {
    // Logs view
    //
    //Future<List<String>> logsList() async
    test('test logsList', () async {
      // TODO
    });

    // Single log view
    //
    //Future<List<String>> retrieveLog(String id) async
    test('test retrieveLog', () async {
      // TODO
    });
  });
}
