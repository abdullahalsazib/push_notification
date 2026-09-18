import 'package:my_app/data/models/project.dart';
import 'package:my_app/data/models/task_model.dart';
import 'package:my_app/data/models/user.dart';
import 'package:uuid/uuid.dart';

class MockRepository {
  final _uuid = const Uuid();

  User getCurrentUser() {
    return User(
      id: '1',
      name: 'Jack',
      email: 'jack@example.com',
      avatarUrl: 'https://i.pravatar.cc/150?u=jack',
    );
  }

  List<Project> getProjects() {
    return [
      Project(id: 'p1', name: 'ChatUAPP', colorHex: '2563EB'),
      Project(id: 'p2', name: 'POS System', colorHex: '16A34A'),
      Project(id: 'p3', name: 'Ecommerce', colorHex: 'D97706'),
    ];
  }

  List<TaskModel> getTasks() {
    return [
      TaskModel(
        id: _uuid.v4(),
        title: 'Implement authentication API',
        projectId: 'p1',
        status: TaskStatus.completed,
        priority: TaskPriority.high,
        estimatedMinutes: 120,
        actualMinutes: 130,
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Dashboard UI improvements',
        projectId: 'p2',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        estimatedMinutes: 180,
        actualMinutes: 105,
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Payment Testing',
        projectId: 'p3',
        status: TaskStatus.planned,
        priority: TaskPriority.medium,
      ),
    ];
  }
}
