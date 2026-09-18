import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/data/models/task_model.dart';
import 'package:my_app/data/repositories/mock_repository.dart';

class LocalRepository {
  static const String _tasksKey = 'worktrack_tasks';
  
  Future<List<TaskModel>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksJson = prefs.getString(_tasksKey);
    
    if (tasksJson == null) {
      // First launch, return mock data and save it
      final mockTasks = MockRepository().getTasks();
      await saveTasks(mockTasks);
      return mockTasks;
    }
    
    final List<dynamic> decodedList = jsonDecode(tasksJson);
    return decodedList.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<void> saveTasks(List<TaskModel> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedList = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_tasksKey, encodedList);
  }
}
