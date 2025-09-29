import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

// tests for TasksViewRequest
void main() {
  final TasksViewRequest? instance = /* TasksViewRequest(...) */ null;
  // TODO add properties to the entity

  group(TasksViewRequest, () {
    // Celery ID for the Task that was run
    // String taskId
    test('to test the property `taskId`', () async {
      // TODO
    });

    // TaskNameEnum taskName
    test('to test the property `taskName`', () async {
      // TODO
    });

    // Name of the file which the Task was run for
    // String taskFileName
    test('to test the property `taskFileName`', () async {
      // TODO
    });

    // Datetime field when the task result was created in UTC
    // DateTime dateCreated
    test('to test the property `dateCreated`', () async {
      // TODO
    });

    // Datetime field when the task was completed in UTC
    // DateTime dateDone
    test('to test the property `dateDone`', () async {
      // TODO
    });

    // The type of task that was run  * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
    // TasksViewTypeEnum type
    test('to test the property `type`', () async {
      // TODO
    });

    // Current state of the task being run  * `FAILURE` - FAILURE * `PENDING` - PENDING * `RECEIVED` - RECEIVED * `RETRY` - RETRY * `REVOKED` - REVOKED * `STARTED` - STARTED * `SUCCESS` - SUCCESS
    // StatusEnum status
    test('to test the property `status`', () async {
      // TODO
    });

    // The data returned by the task
    // String result
    test('to test the property `result`', () async {
      // TODO
    });

    // If the task is acknowledged via the frontend or API
    // bool acknowledged
    test('to test the property `acknowledged`', () async {
      // TODO
    });

    // int owner
    test('to test the property `owner`', () async {
      // TODO
    });
  });
}
