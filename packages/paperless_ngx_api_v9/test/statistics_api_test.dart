import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for StatisticsApi
void main() {
  final instance = PaperlessNgxApiV9().getStatisticsApi();

  group(StatisticsApi, () {
    // Get statistics for the current user
    //
    //Future<Map<String, Object>> statisticsRetrieve() async
    test('test statisticsRetrieve', () async {
      // TODO
    });
  });
}
