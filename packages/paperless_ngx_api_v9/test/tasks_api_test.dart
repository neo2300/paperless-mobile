import 'package:test/test.dart';
import 'package:paperless_ngx_api_v9/paperless_ngx_api_v9.dart';

/// tests for TasksApi
void main() {
  final instance = PaperlessNgxApiV9().getTasksApi();

  group(TasksApi, () {
    // Acknowledge a list of tasks
    //
    //Future<AcknowledgeTasks> acknowledgeTasks({ AcknowledgeTasksRequest acknowledgeTasksRequest }) async
    test('test acknowledgeTasks', () async {
      // TODO
    });

    //Future<List<TasksView>> tasksList({ bool acknowledged, String ordering, String status, String taskName, String type }) async
    test('test tasksList', () async {
      // TODO
    });

    //Future<TasksView> tasksRetrieve(int id) async
    test('test tasksRetrieve', () async {
      // TODO
    });

    //Future<TasksView> tasksRunCreate(TasksViewRequest tasksViewRequest) async
    test('test tasksRunCreate', () async {
      // TODO
    });
  });
}
