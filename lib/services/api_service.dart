import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/association.dart';
import 'package:purrfectmatch/models/message.dart';
import 'package:purrfectmatch/models/room.dart';
import 'package:web_socket_channel/io.dart';
import '../models/cat.dart';
import '../models/annonce.dart';
import '../models/feature_flag.dart';
import '../models/race.dart';
import '../models/user.dart';
import '../models/favoris.dart';
import '../models/rating.dart';
import '../models/notification_token.dart';
import 'package:file_picker/file_picker.dart';
import '../notificationManager.dart';
import './auth_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mime/mime.dart';

class ApiService {
  static String get baseUrl =>
      kIsWeb ? dotenv.env['WEB_BASE_URL']! : dotenv.env['MOBILE_BASE_URL']!;
  static String get wsUrl =>
      kIsWeb ? dotenv.env['WEB_WS_URL']! : dotenv.env['MOBILE_WS_URL']!;

  // Cat methods
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

    final token = AuthService.authToken;
    request.headers['Authorization'] = 'Bearer $token';

    cat.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (selectedFile != null && selectedFile.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploaded_file',
          selectedFile.path!,
          filename: selectedFile.name,
          contentType: MediaType('image', selectedFile.extension ?? 'jpeg'),
        ),
      );
    } else {
      print('File selection error: No file selected or file path is null');
    }

    print('Cat object to be sent:');
    print(jsonEncode(cat.toJson()));
    print('Request fields:');
    print(request.fields);

    var response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      print('Cat created successfully');
    } else {
      print('Failed to create cat: $responseString');
      throw Exception('Failed to create cat profile');
    }
  }

  Future<void> updateCat(Cat cat, PlatformFile? selectedFile) async {
    var request =
    http.MultipartRequest('PUT', Uri.parse('$baseUrl/cats/${cat.ID}'));

    final token = AuthService.authToken;
    request.headers['Authorization'] = 'Bearer $token';

    cat.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (selectedFile != null && selectedFile.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'uploaded_file',
          selectedFile.path!,
          filename: selectedFile.name,
          contentType: MediaType('image', selectedFile.extension ?? 'jpeg'),
        ),
      );
    } else {
      print('File selection error: No file selected or file path is null');
    }

    print('Cat object to be sent:');
    print(jsonEncode(cat.toJson()));
    print('Request fields:');
    print(request.fields);

    var response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      print('Cat updated successfully');
    } else {
      print('Failed to update cat: $responseString');
      throw Exception('Failed to update cat profile');
    }
  }

  Future<void> deleteCat(int catId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/cats/$catId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete cat');
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

    if (response.statusCode == 200) {
      List<dynamic> catsJson = jsonDecode(response.body);
      return catsJson.map((json) => Cat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }

  Future<List<Annonce>> fetchCatsByFilters(age, catSex, race) async {
    final token = AuthService.authToken;
    final filters = {"age": age, "raceId": race.toString(), "sexe": catSex};
    final response = await http.get(
      Uri.parse('$baseUrl/cats/').replace(queryParameters: filters),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> annonceJson = jsonDecode(response.body);
      return annonceJson.map((json) => Annonce.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cats');
    }
  }

  Future<List<Cat>> fetchCatsByUser(String userId) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/cats/user/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> catsJson = jsonDecode(response.body);
      return catsJson.map((json) => Cat.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cats for user');
    }
  }

  // Annonce methods
  Future<List<Annonce>> fetchAllAnnonces() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/annonces'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> annoncesJson = jsonDecode(response.body);
      return annoncesJson.map((json) => Annonce.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load annonces');
    }
  }

  Future<Annonce> createAnnonce(Annonce annonce) async {
    final token = AuthService.authToken;

    print('JSON envoyé au serveur: ${jsonEncode(annonce.toJson())}');

    final response = await http.post(
      Uri.parse('$baseUrl/annonces'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(annonce.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
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

  Future<void> updateAnnonce(Annonce annonce) async {
    final token = AuthService.authToken;
    final response = await http.put(
      Uri.parse('$baseUrl/annonces/${annonce.ID}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(annonce.toJson()),
    );

    print(annonce.toJson());
    if (response.statusCode != 200) {
      throw Exception('Failed to update annonce.');
    }
  }

  Future<void> deleteAnnonce(String annonceId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/annonces/$annonceId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete annonce');
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

  Future<List<Annonce>> fetchUserAnnonces(String userId) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/users/annonces/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      List<dynamic> annoncesJson = jsonDecode(response.body);
      return annoncesJson.map((json) => Annonce.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user annonces');
    }
  }

  // Association methods
  Future<void> createAssociation(
      Association association, String filePath, String fileName) async {
    final token = AuthService.authToken;
    final request =
    http.MultipartRequest('POST', Uri.parse('$baseUrl/associations'));

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';

    // Add JSON fields
    request.fields['name'] = association.Name;
    request.fields['addressRue'] = association.AddressRue;
    request.fields['cp'] = association.Cp;
    request.fields['ville'] = association.Ville;
    request.fields['phone'] = association.Phone;
    request.fields['email'] = association.Email;
    request.fields['ownerId'] = association.OwnerID;
    request.fields['Members'] = jsonEncode(association.Members);

    // Add the file
    request.files.add(
      await http.MultipartFile.fromPath(
        'kbisFile',
        filePath,
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ),
    );

    // Send the request
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      print('Association created successfully');
    } else {
      print('Failed to create association: $responseString');
      throw Exception('Failed to create association: $responseString');
    }
  }

  Future<void> updateAssociation(Association association, PlatformFile? selectedFile) async {
    final token = AuthService.authToken;
    final Uri uri = Uri.parse('$baseUrl/associations/${association.ID}');
    final request = http.MultipartRequest('PUT', uri)
      ..headers['Authorization'] = 'Bearer $token';

    // Convert association to JSON and filter out empty lists and null values
    final filteredData = association.toJson();
    final nonEmptyData = <String, String>{};

    filteredData.forEach((key, value) {
      if (value is List) {
        if (value.isNotEmpty) {
          nonEmptyData[key] = value.join(','); // Format the list correctly
        }
      } else if (value != null) {
        nonEmptyData[key] = value.toString();
      }
    });

    // Afficher l'objet association avant de l'envoyer
    print('Filtered association data: $nonEmptyData');

    nonEmptyData.forEach((key, value) {
      request.fields[key] = value;
    });

    if (selectedFile != null && selectedFile.path != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'kbisFile',
          selectedFile.path!,
          filename: selectedFile.name,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }

    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    print(response.statusCode);
    if (response.statusCode != 200) {
      throw Exception('Failed to update association: $responseString');
    }
  }

  Future<List<Association>> fetchUserAssociations(String userId) async {

    print("ici");
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/associations'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    print("-------------------->");
    print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      List<dynamic> associationsJson = jsonDecode(response.body);
      return associationsJson.map((json) => Association.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user associations');
    }
  }

  Future<List<Association>> fetchAllAssociations() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/associations'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> associationsJson = jsonDecode(response.body);
      return associationsJson
          .map((json) => Association.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load associations');
    }
  }

  Future<Association> fetchAssociationByID(String associationID) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/associations/$associationID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> associationJson = jsonDecode(response.body);
      return Association.fromJson(associationJson);
    } else {
      throw Exception('Failed to load association for ID: $associationID');
    }
  }

  Future<void> updateAssociationVerifyStatus(int associationId, bool verified) async {
    final token = AuthService.authToken;
    final response = await http.put(
      Uri.parse('$baseUrl/associations/$associationId/verify'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'verified': verified}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to verify association');
    }
  }

  Future<void> deleteAssociation(String associationId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/associations/$associationId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete association');
    }
  }

  // User methods
  Future<List<User>> fetchAllUsers() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> usersJson = jsonDecode(response.body);
      return usersJson.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(User user) async {
    final token = AuthService.authToken;
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = jsonDecode(response.body);
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<User> updateUser(User user) async {
    final token = AuthService.authToken;
    final response = await http.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = jsonDecode(response.body);
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to update user.');
    }
  }

  Future<String> updateUserProfilePic(
      String userId, String selectedFilePath, String selectedFileName) async {
    final token = AuthService.authToken;
    var request =
    http.MultipartRequest('POST', Uri.parse('$baseUrl/profile/picture'));

    request.headers['Authorization'] = 'Bearer $token';

    String? mimeType = lookupMimeType(selectedFilePath);
    MediaType contentType;
    if (mimeType != null) {
      var type = mimeType.split('/');
      if (type.length == 2) {
        contentType = MediaType(type[0], type[1]);
      } else {
        throw Exception('Invalid MIME type');
      }
    } else {
      contentType = MediaType('image', 'jpeg');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'uploaded_file',
        selectedFilePath,
        filename: selectedFileName,
        contentType: contentType,
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final responseString = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(responseString);
      return responseData['profilePicURL'];
    } else {
      throw Exception('Failed to update user profile pic');
    }
  }

  Future<void> deleteUser(String userId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  Future<void> deleteUserProfilePic(String userId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$userId/profile/pic'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user profile pic');
    }
  }

  Future<User> fetchUserByID(String? userID) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userJson = jsonDecode(response.body);
      return User.fromJson(userJson);
    } else {
      throw Exception('Failed to load user for ID: $userID');
    }
  }

  // Favorite methods
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

    if (response.statusCode == 201) {
      try {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['success'] == 'true' &&
            responseData['favorite'] != null) {
          return responseData['favorite'];
        } else {
          throw Exception('Failed to create favorite');
        }
      } catch (e) {
        throw Exception('Failed to parse response');
      }
    } else {
      throw Exception('Failed to create favorite');
    }
  }

  Future<List<Favoris>> fetchUserFavorites(String userId) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/favorites/users/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> favorisJson = jsonDecode(response.body);
      return favorisJson.map((json) => Favoris.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user favorites');
    }
  }

  // Rating methods
  Future<List<Rating>> fetchAllRatings() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/ratings'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> ratingsJson = jsonDecode(response.body);
      return ratingsJson.map((json) => Rating.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load ratings');
    }
  }

  Future<List<Rating>> fetchUserRatings(String userId) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/ratings/user/$userId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> ratingsJson = jsonDecode(response.body);
      return ratingsJson.map((json) => Rating.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user ratings');
    }
  }

  Future<Rating> createRating(Rating rating) async {
    final token = AuthService.authToken;

    final body = jsonEncode({
      'mark': rating.mark,
      'comment': rating.comment,
      'userID': rating.userId,
    });

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/ratings'),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> ratingJson = jsonDecode(response.body);
      return Rating.fromJson(ratingJson);
    } else {
      throw Exception('Failed to create rating');
    }
  }

  Future<Rating> updateRating(Rating rating) async {
    final token = AuthService.authToken;

    final body = jsonEncode({
      'mark': rating.mark,
      'comment': rating.comment,
    });

    final response = await http.put(
      Uri.parse('$baseUrl/ratings/${rating.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> ratingJson = jsonDecode(response.body);
      return Rating.fromJson(ratingJson);
    } else {
      throw Exception('Failed to update rating');
    }
  }

  Future<void> deleteRating(int ratingId) async {
    final token = AuthService.authToken;

    final response = await http.delete(
      Uri.parse('$baseUrl/ratings/$ratingId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete rating');
    }
  }

  Future<List<Race>> fetchAllRaces() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/races'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> raceJson = jsonDecode(response.body);
      return raceJson.map((json) => Race.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load races');
    }
  }

  Future<Race> createRace(Race race) async {
    final token = AuthService.authToken;
    final response = await http.post(
      Uri.parse('$baseUrl/races'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(race.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> raceJson = jsonDecode(response.body);
      return Race.fromJson(raceJson);
    } else {
      throw Exception('Failed to create race.');
    }
  }

  Future<Race> updateRace(Race race) async {
    final token = AuthService.authToken;
    final response = await http.put(
      Uri.parse('$baseUrl/races/${race.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(race.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> raceJson = jsonDecode(response.body);
      return Race.fromJson(raceJson);
    } else {
      throw Exception('Failed to update race.');
    }
  }

  Future<void> deleteRace(int raceId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/races/$raceId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete race');
    }
  }

  // Chat methods
  Future<List<Room>> getUserRooms() async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/rooms'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body);
      if (parsed is List<dynamic>) {
        List<Room> rooms = parsed.map((json) {
          return Room.fromModifiedJson(json);
        }).toList();
        return rooms;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  Future<List<Message>> getRoomMessages(int roomID) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/rooms/$roomID'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body);
      if (parsed is List<dynamic>) {
        List<Message> messages = parsed.map((json) {
          return Message.fromJson(json);
        }).toList();
        return messages;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<Message> getLatestMessage(int roomID) async {
    final token = AuthService.authToken;
    final response = await http.get(
      Uri.parse('$baseUrl/rooms/$roomID/latest'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body);
      return Message.fromJsonLastest(parsed);
    } else {
      throw Exception('Failed to load latest message');
    }
  }

  IOWebSocketChannel connectToRoom(int roomID) {
    final token = AuthService.authToken;
    return IOWebSocketChannel.connect(Uri.parse('$wsUrl/ws/$roomID'), headers: {
      'Authorization': 'Bearer $token',
    });
  }

  // Notifications
  Future<NotificationToken> createNotificationToken(String userId, String fcmToken) async {
    final token = AuthService.authToken;
    NotificationToken notificationToken = NotificationToken(userId: userId, token: fcmToken);

    final response = await http.post(
      Uri.parse('$baseUrl/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(notificationToken.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> notificationTokenJson = jsonDecode(response.body);
      return NotificationToken.fromJson(notificationTokenJson);
    } else {
      throw Exception('Failed to create notification token.');
    }
  }

  Future<void> deleteNotificationToken(String notificationTokenId) async {
    final token = AuthService.authToken;
    final response = await http.delete(
      Uri.parse('$baseUrl/notifications/$notificationTokenId'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete notification token');
    }
  }


  String serveDefaultProfilePicture() {
    return '$baseUrl/assets/images/default_picture.png';
  }

  // FEATURE FLAG
  Future<List<FeatureFlag>> fetchAllFeatureFlags() async {
    print("ok");
    final token = AuthService.authToken;
    print("token: $token");
    final response = await http.get(
      Uri.parse('$baseUrl/feature-flags'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> featureFlagsJson = jsonDecode(response.body);
      return featureFlagsJson.map((json) => FeatureFlag.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load feature flags');
    }
  }

  Future<void> updateFeatureFlagStatus(int featureFlagId, bool isEnabled) async {
    final token = AuthService.authToken;
    print('isEnabled: $isEnabled');
    final response = await http.put(
      Uri.parse('$baseUrl/feature-flags/$featureFlagId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'isEnabled': isEnabled}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update feature flag');
    }
  }
}
