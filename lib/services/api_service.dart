import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cat.dart';
import '../models/annonce.dart';
import '../models/user.dart';
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


  Future<List<Cat>> fetchAllCats() async {
    final token = AuthService.authToken;
    final response = await http.get(Uri.parse('$baseUrl/cats'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      });

    print('$baseUrl/cats');
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> catsJson = jsonDecode(response.body);
      return catsJson.map((json) => Cat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }



  //*annonces
  Future<List<Annonce>> fetchAllAnnonces() async {
    final token = AuthService.authToken;
    final response = await http.get(Uri.parse('$baseUrl/annonces'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        });

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
      throw Exception('Non autorisé. Veuillez vérifier vos informations d\'authentification');
    } else if (response.statusCode == 500) {
      throw Exception('Erreur interne du serveur');
    } else {
      throw Exception('Échec de la création de l\'annonce');
    }
  }

  //USER
  Future<User> fetchCurrentUser() async {
    final token = AuthService.authToken;
    final response = await http.get(Uri.parse('$baseUrl/users/current'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      });

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user profile');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user profile');
    }
  }

  Future<User> updateUser(User user) async {
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

  Future<void> updateUserProfilePic(PlatformFile selectedFile) async {
    final token = AuthService.authToken;
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/users/{id}/profile/pic'));

    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(
      http.MultipartFile(
        'uploaded_file',
        selectedFile.readStream!,
        selectedFile.size,
        filename: selectedFile.name,
      ),
    );

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile pic');
    }
  }

  Future<void> deleteUserProfile() async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/users/{user.id}'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user profile');
    }
  }

  Future<void> deleteUserProfilePic() async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/users/{user.id}/profile/pic'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user profile pic');
    }
  }




}
