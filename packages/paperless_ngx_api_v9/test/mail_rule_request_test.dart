import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

// tests for MailRuleRequest
void main() {
  final MailRuleRequest? instance = /* MailRuleRequest(...) */ null;
  // TODO add properties to the entity

  group(MailRuleRequest, () {
    // String name
    test('to test the property `name`', () async {
      // TODO
    });

    // int account
    test('to test the property `account`', () async {
      // TODO
    });

    // bool enabled
    test('to test the property `enabled`', () async {
      // TODO
    });

    // Subfolders must be separated by a delimiter, often a dot ('.') or slash ('/'), but it varies by mail server.
    // String folder
    test('to test the property `folder`', () async {
      // TODO
    });

    // String filterFrom
    test('to test the property `filterFrom`', () async {
      // TODO
    });

    // String filterTo
    test('to test the property `filterTo`', () async {
      // TODO
    });

    // String filterSubject
    test('to test the property `filterSubject`', () async {
      // TODO
    });

    // String filterBody
    test('to test the property `filterBody`', () async {
      // TODO
    });

    // Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
    // String filterAttachmentFilenameInclude
    test('to test the property `filterAttachmentFilenameInclude`', () async {
      // TODO
    });

    // Do not consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
    // String filterAttachmentFilenameExclude
    test('to test the property `filterAttachmentFilenameExclude`', () async {
      // TODO
    });

    // Specified in days.
    // int maximumAge
    test('to test the property `maximumAge`', () async {
      // TODO
    });

    // MailRuleActionEnum action
    test('to test the property `action`', () async {
      // TODO
    });

    // String actionParameter (default value: '')
    test('to test the property `actionParameter`', () async {
      // TODO
    });

    // AssignTitleFromEnum assignTitleFrom
    test('to test the property `assignTitleFrom`', () async {
      // TODO
    });

    // List<int> assignTags
    test('to test the property `assignTags`', () async {
      // TODO
    });

    // AssignCorrespondentFromEnum assignCorrespondentFrom
    test('to test the property `assignCorrespondentFrom`', () async {
      // TODO
    });

    // int assignCorrespondent
    test('to test the property `assignCorrespondent`', () async {
      // TODO
    });

    // int assignDocumentType
    test('to test the property `assignDocumentType`', () async {
      // TODO
    });

    // bool assignOwnerFromRule
    test('to test the property `assignOwnerFromRule`', () async {
      // TODO
    });

    // int order
    test('to test the property `order`', () async {
      // TODO
    });

    // Inline attachments include embedded images, so it's best to combine this option with a filename filter.  * `1` - Only process attachments. * `2` - Process all files, including 'inline' attachments.
    // AttachmentTypeEnum attachmentType
    test('to test the property `attachmentType`', () async {
      // TODO
    });

    // ConsumptionScopeEnum consumptionScope
    test('to test the property `consumptionScope`', () async {
      // TODO
    });

    // PdfLayoutEnum pdfLayout
    test('to test the property `pdfLayout`', () async {
      // TODO
    });

    // int owner
    test('to test the property `owner`', () async {
      // TODO
    });

    // CorrespondentRequestSetPermissions setPermissions
    test('to test the property `setPermissions`', () async {
      // TODO
    });
  });
}
