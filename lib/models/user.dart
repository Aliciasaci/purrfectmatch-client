import 'package:purrfectmatch/models/role.dart';

import 'association.dart';

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
  final List<Association> associations;

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
    this.associations = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<Role> rolesList = [];
    if (json['roles'] != null) {
      rolesList = List<Role>.from(json['roles'].map((role) => Role.fromJson(role)));
    }

    List<Association> associationsList = [];
    if (json['associations'] != null) {
      associationsList = List<Association>.from(json['associations'].map((association) => Association.fromJson(association)));
    }

    return User(
      id: json['ID'],
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']).toIso8601String() : null,
      updatedAt: json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']).toIso8601String() : null,
      name: json['Name'] ?? '',
      email: json['Email'] ?? '',
      password: json['Password'] ?? '',
      addressRue: json['AddressRue'] ?? '',
      cp: json['Cp'] ?? '',
      ville: json['Ville'] ?? '',
      profilePicURL: json['ProfilePicURL'] ?? '',
      roles: rolesList,
      associations: associationsList,
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
      'associations': associations.map((association) => association.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '{name: $name, email: $email, addressRue: $addressRue, cp: $cp, ville: $ville, password: $password, profilePicURL: $profilePicURL, createdAt: $createdAt, roles: $roles, associations: $associations }';
  }
}
