import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static String? authToken;

  Future<User> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        print("Login Success: ${response.body}");

        // Store the token in the global variable
        authToken = responseBody['token'];

        return User.fromJson(responseBody);
      } else {
        print("Login Failed: Status Code ${response.statusCode}, Body: ${response.body}");
        throw Exception('Failed to login with status code ${response.statusCode}');
      }
    } catch (e) {
      print("Exception occurred: $e");
      throw Exception('Failed to send login request');
    }
  }

  void logout() {
    authToken = null;
    print("User logged out, token cleared.");
  }
}

