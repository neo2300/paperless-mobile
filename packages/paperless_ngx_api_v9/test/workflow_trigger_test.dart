import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

// tests for WorkflowTrigger
void main() {
  final WorkflowTrigger? instance = /* WorkflowTrigger(...) */ null;
  // TODO add properties to the entity

  group(WorkflowTrigger, () {
    // int id
    test('to test the property `id`', () async {
      // TODO
    });

    // List<SourcesEnum> sources
    test('to test the property `sources`', () async {
      // TODO
    });

    // WorkflowTriggerTypeEnum type
    test('to test the property `type`', () async {
      // TODO
    });

    // Only consume documents with a path that matches this if specified. Wildcards specified as * are allowed. Case insensitive.
    // String filterPath
    test('to test the property `filterPath`', () async {
      // TODO
    });

    // Only consume documents which entirely match this filename if specified. Wildcards such as *.pdf or *invoice* are allowed. Case insensitive.
    // String filterFilename
    test('to test the property `filterFilename`', () async {
      // TODO
    });

    // int filterMailrule
    test('to test the property `filterMailrule`', () async {
      // TODO
    });

    // WorkflowTriggerMatchingAlgorithmEnum matchingAlgorithm
    test('to test the property `matchingAlgorithm`', () async {
      // TODO
    });

    // String match
    test('to test the property `match`', () async {
      // TODO
    });

    // bool isInsensitive
    test('to test the property `isInsensitive`', () async {
      // TODO
    });

    // List<int> filterHasTags
    test('to test the property `filterHasTags`', () async {
      // TODO
    });

    // int filterHasCorrespondent
    test('to test the property `filterHasCorrespondent`', () async {
      // TODO
    });

    // int filterHasDocumentType
    test('to test the property `filterHasDocumentType`', () async {
      // TODO
    });

    // The number of days to offset the schedule trigger by.
    // int scheduleOffsetDays
    test('to test the property `scheduleOffsetDays`', () async {
      // TODO
    });

    // If the schedule should be recurring.
    // bool scheduleIsRecurring
    test('to test the property `scheduleIsRecurring`', () async {
      // TODO
    });

    // The number of days between recurring schedule triggers.
    // int scheduleRecurringIntervalDays
    test('to test the property `scheduleRecurringIntervalDays`', () async {
      // TODO
    });

    // The field to check for a schedule trigger.  * `added` - Added * `created` - Created * `modified` - Modified * `custom_field` - Custom Field
    // ScheduleDateFieldEnum scheduleDateField
    test('to test the property `scheduleDateField`', () async {
      // TODO
    });

    // int scheduleDateCustomField
    test('to test the property `scheduleDateCustomField`', () async {
      // TODO
    });
  });
}
