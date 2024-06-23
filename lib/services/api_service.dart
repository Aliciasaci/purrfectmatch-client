import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat.dart';
import '../models/annonce.dart';
import '../models/favoris.dart';
import 'package:file_picker/file_picker.dart';
import './auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  Future<Cat> fetchCatByID(String? catID) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/cats/$catID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> catJson = jsonDecode(response.body);
      print(response.body);

      return Cat.fromJson(catJson);
    } else {
      throw Exception('Failed to load cat for ID: $catID');
    }
  }

  Future<Cat> fetchCatProfile() async {
    final response = await http.get(Uri.parse('$baseUrl/cats/'));

    if (response.statusCode == 200) {
      return Cat.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cat profile');
    }
  }

  Future<void> createCat(Cat cat, PlatformFile? selectedFile) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/cats'));

    request.fields['name'] = cat.name;
    request.fields['sexe'] = cat.sexe;
    request.fields['birthDate'] = cat.birthDate;
    request.fields['lastVaccineDate'] = cat.lastVaccineDate;
    request.fields['lastVaccineName'] = cat.lastVaccineName;
    request.fields['color'] = cat.color;
    request.fields['behavior'] = cat.behavior;
    request.fields['race'] = cat.race;
    request.fields['description'] = cat.description;
    request.fields['sexe'] = cat.sexe;
    request.fields['sterilized'] = cat.sterilized.toString();
    request.fields['reserved'] = cat.reserved.toString();

    if (selectedFile != null) {
      request.files.add(
        http.MultipartFile(
          'uploaded_file',
          selectedFile.readStream!,
          selectedFile.size,
          filename: selectedFile.name,
        ),
      );
    }

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to create cat profile');
    }
  }

  Future<List<Cat>> fetchAllCats() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/cats'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    print('$baseUrl/cats');
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> catsJson = jsonDecode(response.body);
      print(response.body);
      return catsJson.map((json) => Cat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }

  Future<List<Annonce>> fetchAllAnnonces() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/annonces'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    print('$baseUrl/annonces');
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> annoncesJson = jsonDecode(response.body);
      return annoncesJson.map((json) => Annonce.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load annonces');
    }
  }

  Future<Annonce> createAnnonce(Annonce annonce) async {
    final token = AuthService.authToken;
    final response = await http.post(
      Uri.parse('$baseUrl/annonces'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(annonce.toJson()),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
      return Annonce.fromJson(responseData);
    } else if (response.statusCode == 400) {
      throw Exception('Champs manquants ou invalides dans la requête');
    } else if (response.statusCode == 401) {
      throw Exception(
          'Non autorisé. Veuillez vérifier vos informations d\'authentification');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur interne du serveur');
    } else {
      throw Exception('Échec de la création de l\'annonce');
    }
  }

  Future<List<Annonce>> fetchUserAnnonces() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/users/annonces/b7aadd15-ca69-4ea1-a92c-e93669ad0b22'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    print('$baseUrl/users/annonces');
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> annoncesJson = jsonDecode(response.body);
      return annoncesJson.map((json) => Annonce.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user annonces');
    }
  }

  Future<List<Favoris>> fetchUserFavorites() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/favorites/users/b7aadd15-ca69-4ea1-a92c-e93669ad0b22'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    print('$baseUrl/user/favorites');
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> favorisJson = jsonDecode(response.body);
      return favorisJson.map((json) => Favoris.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user favorites');
    }
  }

  Future<Annonce> fetchAnnonceByID(String annonceID) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/annonces/$annonceID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> annonceJson = jsonDecode(response.body);
      return Annonce.fromJson(annonceJson);
    } else {
      throw Exception('Failed to load annonce for ID: $annonceID');
    }
  }

  Future<Map<String, dynamic>> createFavorite(int? annonceID) async {
    final token = AuthService.authToken;
    final response = await http.post(
      Uri.parse('$baseUrl/favorites'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'annonceID': annonceID.toString()}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == 'true' && responseData['favorite'] != null) {
          return responseData['favorite'];
        } else {
          throw Exception('Failed to create favorite');
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        throw Exception('Failed to parse response');
      }
    } else {
      throw Exception('Failed to create favorite');
    }
  }
}
