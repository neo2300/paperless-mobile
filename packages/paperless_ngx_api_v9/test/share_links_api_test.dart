import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for ShareLinksApi
void main() {
  final instance = PaperlessNgxApiV9().getShareLinksApi();

  group(ShareLinksApi, () {
    //Future<ShareLink> shareLinksCreate({ ShareLinkRequest shareLinkRequest }) async
    test('test shareLinksCreate', () async {
      // TODO
    });

    //Future shareLinksDestroy(int id) async
    test('test shareLinksDestroy', () async {
      // TODO
    });

    //Future<PaginatedShareLinkList> shareLinksList({ DateTime createdDateGt, DateTime createdDateGte, DateTime createdDateLt, DateTime createdDateLte, num createdDay, DateTime createdGt, DateTime createdGte, DateTime createdLt, DateTime createdLte, num createdMonth, num createdYear, DateTime expirationDateGt, DateTime expirationDateGte, DateTime expirationDateLt, DateTime expirationDateLte, num expirationDay, DateTime expirationGt, DateTime expirationGte, DateTime expirationLt, DateTime expirationLte, num expirationMonth, num expirationYear, String ordering, int page, int pageSize }) async
    test('test shareLinksList', () async {
      // TODO
    });

    //Future<ShareLink> shareLinksPartialUpdate(int id, { PatchedShareLinkRequest patchedShareLinkRequest }) async
    test('test shareLinksPartialUpdate', () async {
      // TODO
    });

    //Future<ShareLink> shareLinksRetrieve(int id) async
    test('test shareLinksRetrieve', () async {
      // TODO
    });

    //Future<ShareLink> shareLinksUpdate(int id, { ShareLinkRequest shareLinkRequest }) async
    test('test shareLinksUpdate', () async {
      // TODO
    });
  });
}
