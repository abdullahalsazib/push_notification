import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app/models/user_model.dart';

class UserApiServices {
  static const String baseUrl = "https://jsonplaceholder.typicode.com";

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      return jsonData.map((json) => User.fromJson(json)).toList();
    }
    throw Exception('Failed to load users: ${response.statusCode}');
  }
}
