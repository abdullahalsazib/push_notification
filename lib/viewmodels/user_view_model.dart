import 'package:flutter/material.dart';
import 'package:my_app/models/user_model.dart';
import 'package:my_app/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  UserViewModel(this._userRepository);
  List<User> _users = [];
  bool _loading = false;
  String? _error;

  List<User> get users => _users;
  bool get isLoading => _loading;
  String? get error => _error;

  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await _userRepository.getUsers();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
