import 'package:my_app/data/models/task_model.dart';

class WorkEntry {
  final String id;
  final String title;
  final String projectId;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final TaskStatus status;
  final TaskPriority priority;

  WorkEntry({
    required this.id,
    required this.title,
    required this.projectId,
    required this.date,
    this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    this.status = TaskStatus.completed,
    this.priority = TaskPriority.medium,
  });
}
