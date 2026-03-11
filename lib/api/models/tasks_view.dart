//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:paperless_mobile/api/models/status_enum.dart';
import 'package:paperless_mobile/api/models/task_name_enum.dart';
import 'package:paperless_mobile/api/models/tasks_view_type_enum.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/src/equatable_utils.dart';

part 'tasks_view.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TasksView {
  /// Returns a new [TasksView] instance.
  TasksView({
    required this.id,

    required this.taskId,

    this.taskName,

    this.taskFileName,

    this.dateCreated,

    this.dateDone,

    this.type,

    this.status,

    this.result,

    this.acknowledged,

    required this.relatedDocument,

    this.owner,
  });

  @JsonKey(name: r'id', includeIfNull: false)
  final int id;

  /// Celery ID for the Task that was run
  @JsonKey(name: r'task_id', includeIfNull: false)
  final String taskId;

  @JsonKey(name: r'task_name', includeIfNull: false)
  final TaskNameEnum? taskName;

  /// Name of the file which the Task was run for
  @JsonKey(name: r'task_file_name', includeIfNull: false)
  final String? taskFileName;

  /// Datetime field when the task result was created in UTC
  @JsonKey(name: r'date_created', includeIfNull: false)
  final DateTime? dateCreated;

  /// Datetime field when the task was completed in UTC
  @JsonKey(name: r'date_done', includeIfNull: false)
  final DateTime? dateDone;

  /// The type of task that was run  * `auto_task` - Auto Task * `scheduled_task` - Scheduled Task * `manual_task` - Manual Task
  @JsonKey(name: r'type', includeIfNull: false)
  final TasksViewTypeEnum? type;

  /// Current state of the task being run  * `FAILURE` - FAILURE * `PENDING` - PENDING * `RECEIVED` - RECEIVED * `RETRY` - RETRY * `REVOKED` - REVOKED * `STARTED` - STARTED * `SUCCESS` - SUCCESS
  @JsonKey(name: r'status', includeIfNull: false)
  final StatusEnum? status;

  /// The data returned by the task
  @JsonKey(name: r'result', includeIfNull: false)
  final String? result;

  /// If the task is acknowledged via the frontend or API
  @JsonKey(name: r'acknowledged', includeIfNull: false)
  final bool? acknowledged;

  @JsonKey(name: r'related_document', includeIfNull: true)
  final String? relatedDocument;

  @JsonKey(name: r'owner', includeIfNull: false)
  final int? owner;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TasksView &&
            runtimeType == other.runtimeType &&
            equals(
              [
                id,
                taskId,
                taskName,
                taskFileName,
                dateCreated,
                dateDone,
                type,
                status,
                result,
                acknowledged,
                relatedDocument,
                owner,
              ],
              [
                other.id,
                other.taskId,
                other.taskName,
                other.taskFileName,
                other.dateCreated,
                other.dateDone,
                other.type,
                other.status,
                other.result,
                other.acknowledged,
                other.relatedDocument,
                other.owner,
              ],
            );
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      mapPropsToHashCode([
        id,
        taskId,
        taskName,
        taskFileName,
        dateCreated,
        dateDone,
        type,
        status,
        result,
        acknowledged,
        relatedDocument,
        owner,
      ]);

  factory TasksView.fromJson(Map<String, dynamic> json) =>
      _$TasksViewFromJson(json);

  Map<String, dynamic> toJson() => _$TasksViewToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
