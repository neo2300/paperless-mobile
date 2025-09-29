import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for WorkflowsApi
void main() {
  final instance = PaperlessNgxApiV9().getWorkflowsApi();

  group(WorkflowsApi, () {
    //Future<Workflow> workflowsCreate(WorkflowRequest workflowRequest) async
    test('test workflowsCreate', () async {
      // TODO
    });

    //Future workflowsDestroy(int id) async
    test('test workflowsDestroy', () async {
      // TODO
    });

    //Future<PaginatedWorkflowList> workflowsList({ int page, int pageSize }) async
    test('test workflowsList', () async {
      // TODO
    });

    //Future<Workflow> workflowsPartialUpdate(int id, { PatchedWorkflowRequest patchedWorkflowRequest }) async
    test('test workflowsPartialUpdate', () async {
      // TODO
    });

    //Future<Workflow> workflowsRetrieve(int id) async
    test('test workflowsRetrieve', () async {
      // TODO
    });

    //Future<Workflow> workflowsUpdate(int id, WorkflowRequest workflowRequest) async
    test('test workflowsUpdate', () async {
      // TODO
    });
  });
}
