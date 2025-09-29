import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for SearchApi
void main() {
  final instance = PaperlessNgxApiV9().getSearchApi();

  group(SearchApi, () {
    // Get a list of all available tags
    //
    //Future<List<String>> searchAutocompleteList({ int limit, String term }) async
    test('test searchAutocompleteList', () async {
      // TODO
    });

    // Global search
    //
    //Future<SearchResult> searchRetrieve(String query, { bool dbOnly }) async
    test('test searchRetrieve', () async {
      // TODO
    });
  });
}
