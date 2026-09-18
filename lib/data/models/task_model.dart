enum TaskStatus { planned, inProgress, completed, blocked }
enum TaskPriority { low, medium, high, urgent }

class TaskModel {
  final String id;
  final String title;
  final String projectId;
  final TaskStatus status;
  final TaskPriority priority;
  final int estimatedMinutes;
  final int actualMinutes;

  TaskModel({
    required this.id,
    required this.title,
    required this.projectId,
    this.status = TaskStatus.planned,
    this.priority = TaskPriority.medium,
    this.estimatedMinutes = 0,
    this.actualMinutes = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'projectId': projectId,
      'status': status.name,
      'priority': priority.name,
      'estimatedMinutes': estimatedMinutes,
      'actualMinutes': actualMinutes,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      projectId: json['projectId'],
      status: TaskStatus.values.firstWhere((e) => e.name == json['status'], orElse: () => TaskStatus.planned),
      priority: TaskPriority.values.firstWhere((e) => e.name == json['priority'], orElse: () => TaskPriority.medium),
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      actualMinutes: json['actualMinutes'] ?? 0,
    );
  }
}
