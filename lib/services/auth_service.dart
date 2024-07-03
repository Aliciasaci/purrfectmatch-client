import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user.dart';

class AuthService {
  static String get baseUrl => kIsWeb ? dotenv.env['WEB_BASE_URL']! : dotenv.env['MOBILE_BASE_URL']!;
  static String? authToken;

  Future<void> login(String email, String password) async {
    try {
        final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['token'] == null) {
          throw Exception('Le token est absent dans la réponse');
        }
        authToken = responseBody['token'];
        await getCurrentUser();
      } else if (response.statusCode == 401) {
        throw AuthException("Connexion refusée. Coordonnées invalides.");
      } else if (response.statusCode == 404) {
        throw AuthException("Connexion refusée. Utilisateur introuvable.");
      } else {
        throw AuthException('Échec de la connexion avec le code d\'état ${response.statusCode}');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      } else {
        throw Exception('Échec de l\'envoi de la requête de connexion');
      }
    }
  }

  Future<void> register(String name, String email, String password, String addressRue, String cp, String ville) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "addressRue": addressRue,
          "cp": cp,
          "ville": ville
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseBody['token'] == null) {
          throw Exception('Le token est absent dans la réponse');
        }
        authToken = responseBody['token'];
      } else {
        throw AuthException('Échec de l\'inscription : code d\'état ${response.statusCode}');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      } else {
        print('Exception: $e');
        throw Exception('Échec de l\'envoi de la requête d\'inscription');
      }
    }
  }

  Future<User> getCurrentUser() async {
    final response = await http.get(Uri.parse('$baseUrl/users/current'),
        headers: <String, String>{
          'Authorization': 'Bearer $authToken',
        });

    if (response.statusCode == 200) {
      print('Response body current user: ${response.body}');
      print('User : ${User.fromJson(jsonDecode(response.body))}');
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch current user data');
    }
  }

  Future<User> updateProfile(User user) async {
    final token = AuthService.authToken;
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': 'Bearer $token',
      },
      body: {
        'name': user.name,
        'email': user.email,
        'addressRue': user.addressRue,
        'cp': user.cp,
        'ville': user.ville,
        if (user.password != null) 'password': user.password!,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user profile');
    }
  }

  void logout() {
    authToken = null;
    print("Utilisateur déconnecté, token effacé.");
  }
}


class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
