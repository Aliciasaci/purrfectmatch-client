import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8080';
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
        // Stocker le token dans la variable globale
        authToken = responseBody['token'];
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
          'name': name,
          'email': email,
          'password': password,
          'addressRue': addressRue,
          'cp': cp,
          'ville': ville,
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['token'] == null) {
          throw Exception('Le token est absent dans la réponse');
        }
        // Stocker le token dans la variable globale
        authToken = responseBody['token'];
      } else if (response.statusCode == 401) {
        throw AuthException("Inscription refusée. Coordonnées invalides.");
      } else if (response.statusCode == 404) {
        throw AuthException("Inscription refusée. Utilisateur introuvable.");
      } else {
        throw AuthException('Échec de l\'inscription avec le code d\'état ${response.statusCode}');
      }
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      } else {
        throw Exception('Échec de l\'envoi de la requête d\'inscription');
      }
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
