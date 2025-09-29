import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for MailRulesApi
void main() {
  final instance = PaperlessNgxApiV9().getMailRulesApi();

  group(MailRulesApi, () {
    //Future<MailRule> mailRulesCreate(MailRuleRequest mailRuleRequest) async
    test('test mailRulesCreate', () async {
      // TODO
    });

    //Future mailRulesDestroy(int id) async
    test('test mailRulesDestroy', () async {
      // TODO
    });

    //Future<PaginatedMailRuleList> mailRulesList({ int page, int pageSize }) async
    test('test mailRulesList', () async {
      // TODO
    });

    //Future<MailRule> mailRulesPartialUpdate(int id, { PatchedMailRuleRequest patchedMailRuleRequest }) async
    test('test mailRulesPartialUpdate', () async {
      // TODO
    });

    //Future<MailRule> mailRulesRetrieve(int id) async
    test('test mailRulesRetrieve', () async {
      // TODO
    });

    //Future<MailRule> mailRulesUpdate(int id, MailRuleRequest mailRuleRequest) async
    test('test mailRulesUpdate', () async {
      // TODO
    });
  });
}
