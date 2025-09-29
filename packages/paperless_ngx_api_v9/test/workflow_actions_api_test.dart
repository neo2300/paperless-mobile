import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for WorkflowActionsApi
void main() {
  final instance = PaperlessNgxApiV9().getWorkflowActionsApi();

  group(WorkflowActionsApi, () {
    //Future<WorkflowAction> workflowActionsCreate({ WorkflowActionRequest workflowActionRequest }) async
    test('test workflowActionsCreate', () async {
      // TODO
    });

    //Future workflowActionsDestroy(int id) async
    test('test workflowActionsDestroy', () async {
      // TODO
    });

    //Future<PaginatedWorkflowActionList> workflowActionsList({ int page, int pageSize }) async
    test('test workflowActionsList', () async {
      // TODO
    });

    //Future<WorkflowAction> workflowActionsPartialUpdate(int id, { PatchedWorkflowActionRequest patchedWorkflowActionRequest }) async
    test('test workflowActionsPartialUpdate', () async {
      // TODO
    });

    //Future<WorkflowAction> workflowActionsRetrieve(int id) async
    test('test workflowActionsRetrieve', () async {
      // TODO
    });

    //Future<WorkflowAction> workflowActionsUpdate(int id, { WorkflowActionRequest workflowActionRequest }) async
    test('test workflowActionsUpdate', () async {
      // TODO
    });
  });
}
