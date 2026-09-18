import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:my_app/data/models/task_model.dart';

class TimerProvider extends ChangeNotifier {
  TaskModel? _activeTask;
  int _seconds = 0;
  Timer? _timer;
  bool _isRunning = false;

  TaskModel? get activeTask => _activeTask;
  int get seconds => _seconds;
  bool get isRunning => _isRunning;

  void setTask(TaskModel task) {
    _activeTask = task;
    _seconds = 0;
    _isRunning = false;
    notifyListeners();
  }

  void toggleTimer() {
    if (_activeTask == null) return;
    
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _seconds++;
        notifyListeners();
      });
    }
    _isRunning = !_isRunning;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    // We don't clear the task immediately so the UI can prompt to save it.
    notifyListeners();
  }
  
  void clear() {
    _timer?.cancel();
    _isRunning = false;
    _activeTask = null;
    _seconds = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
