import 'package:my_app/models/user_model.dart';
import 'package:my_app/services/user_api_services.dart';

class UserRepository {
  final UserApiServices _apiServices;

  UserRepository(this._apiServices);

  Future<List<User>> getUsers() async {
    return await _apiServices.fetchUsers();
  }
}
