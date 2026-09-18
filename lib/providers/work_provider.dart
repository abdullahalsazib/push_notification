import 'package:flutter/foundation.dart';
import 'package:my_app/data/models/task_model.dart';
import 'package:my_app/data/repositories/local_repository.dart';

class WorkProvider extends ChangeNotifier {
  final LocalRepository _repository = LocalRepository();

  List<TaskModel> _tasks = [];
  bool _isLoading = true;

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;

  WorkProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _repository.getTasks();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    _tasks.add(task);
    notifyListeners();
    await _repository.saveTasks(_tasks);
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
      await _repository.saveTasks(_tasks);
    }
  }
}
