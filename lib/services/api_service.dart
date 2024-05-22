import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  Future<Cat> fetchCatProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/cats/'));

    if (response.statusCode == 200) {
      return Cat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cat profile');
    }
  }

  Future<void> createCat(Cat cat) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cats'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cat.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create cat profile');
    }
  }
}