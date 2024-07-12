import 'package:purrfectmatch/models/role.dart';

class User {
  final String? id;
  final String name;
  final String email;
  final String addressRue;
  final String cp;
  final String ville;
  final String? password;
  final String? profilePicURL;
  final String? createdAt;
  final String? updatedAt;
  final List<Role> roles;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.addressRue,
    required this.cp,
    required this.ville,
    this.password,
    this.profilePicURL,
    this.createdAt,
    this.updatedAt,
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Role> rolesList = [];
    if (json['Roles'] != null) {
      rolesList =
          List<Role>.from(json['Roles'].map((role) => Role.fromJson(role)));
    }

    return User(
      id: json['ID'],
      createdAt: json['CreatedAt'] != null
          ? DateTime.parse(json['CreatedAt']).toIso8601String()
          : null,
      updatedAt: json['UpdatedAt'] != null
          ? DateTime.parse(json['UpdatedAt']).toIso8601String()
          : null,
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      password: json['Password'] ?? '',
      addressRue: json['AddressRue'] ?? '',
      cp: json['Cp'] ?? '',
      ville: json['Ville'] ?? '',
      profilePicURL: json['ProfilePicURL'] ?? '',
      roles: rolesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'addressRue': addressRue,
      'cp': cp,
      'ville': ville,
      'password': password,
      'profilePicURL': profilePicURL,
      'createdAt': createdAt,
      'roles': roles.map((role) => role.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '{name: $name, email: $email, addressRue: $addressRue, cp: $cp, ville: $ville, password: $password, profilePicURL: $profilePicURL, createdAt: $createdAt, roles: $roles}';
  }
}
