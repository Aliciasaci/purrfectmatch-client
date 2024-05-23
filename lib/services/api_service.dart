import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat.dart';
import '../models/annonce.dart';
import 'package:file_picker/file_picker.dart';
import './auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

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

  Future<Annonce> fetchAnnonces(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/annonces/$id'));

    if (response.statusCode == 200) {
      return Annonce.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load annonce');
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

    if (response.statusCode == 201) {
      print(jsonDecode(response.body));
      return Annonce.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception('Champs manquants ou invalides dans la requête');
    } else if (response.statusCode == 401) {
      throw Exception('Non autorisé. Veuillez vérifier vos informations d\'authentification');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur interne du serveur');
    } else {
      throw Exception('Échec de la création de l\'annonce');
    }
  }
}
