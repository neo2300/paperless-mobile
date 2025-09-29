import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for MailAccountsApi
void main() {
  final instance = PaperlessNgxApiV9().getMailAccountsApi();

  group(MailAccountsApi, () {
    // Manually process the selected mail account for new messages.
    //
    //Future<MailAccountProcessResponse> mailAccountProcess(int id, MailAccountRequest mailAccountRequest) async
    test('test mailAccountProcess', () async {
      // TODO
    });

    // Test a mail account
    //
    //Future<MailAccountTestResponse> mailAccountTest(MailAccountRequest mailAccountRequest) async
    test('test mailAccountTest', () async {
      // TODO
    });

    //Future<MailAccount> mailAccountsCreate(MailAccountRequest mailAccountRequest) async
    test('test mailAccountsCreate', () async {
      // TODO
    });

    //Future mailAccountsDestroy(int id) async
    test('test mailAccountsDestroy', () async {
      // TODO
    });

    //Future<PaginatedMailAccountList> mailAccountsList({ int page, int pageSize }) async
    test('test mailAccountsList', () async {
      // TODO
    });

    //Future<MailAccount> mailAccountsPartialUpdate(int id, { PatchedMailAccountRequest patchedMailAccountRequest }) async
    test('test mailAccountsPartialUpdate', () async {
      // TODO
    });

    //Future<MailAccount> mailAccountsRetrieve(int id) async
    test('test mailAccountsRetrieve', () async {
      // TODO
    });

    //Future<MailAccount> mailAccountsUpdate(int id, MailAccountRequest mailAccountRequest) async
    test('test mailAccountsUpdate', () async {
      // TODO
    });
  });
}
