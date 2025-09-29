import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for WorkflowTriggersApi
void main() {
  final instance = PaperlessNgxApiV9().getWorkflowTriggersApi();

  group(WorkflowTriggersApi, () {
    //Future<WorkflowTrigger> workflowTriggersCreate(WorkflowTriggerRequest workflowTriggerRequest) async
    test('test workflowTriggersCreate', () async {
      // TODO
    });

    //Future workflowTriggersDestroy(int id) async
    test('test workflowTriggersDestroy', () async {
      // TODO
    });

    //Future<PaginatedWorkflowTriggerList> workflowTriggersList({ int page, int pageSize }) async
    test('test workflowTriggersList', () async {
      // TODO
    });

    //Future<WorkflowTrigger> workflowTriggersPartialUpdate(int id, { PatchedWorkflowTriggerRequest patchedWorkflowTriggerRequest }) async
    test('test workflowTriggersPartialUpdate', () async {
      // TODO
    });

    //Future<WorkflowTrigger> workflowTriggersRetrieve(int id) async
    test('test workflowTriggersRetrieve', () async {
      // TODO
    });

    //Future<WorkflowTrigger> workflowTriggersUpdate(int id, WorkflowTriggerRequest workflowTriggerRequest) async
    test('test workflowTriggersUpdate', () async {
      // TODO
    });
  });
}
