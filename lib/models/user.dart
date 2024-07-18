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
    if (json['Roles'] != null) {
      rolesList =
          List<Role>.from(json['Roles'].map((role) => Role.fromJson(role)));
    }

    List<Association> associationsList = [];
    if (json['Associations'] != null) {
      associationsList = List<Association>.from(json['Associations']
          .map((association) => Association.fromJson(association)));
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
      'associations':
          associations.map((association) => association.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return '{name: $name, email: $email, addressRue: $addressRue, cp: $cp, ville: $ville, password: $password, profilePicURL: $profilePicURL, createdAt: $createdAt, roles: $roles, associations: $associations }';
  }

  User copyWith({
    String? profilePicURL,
    String? name,
    String? email,
    String? addressRue,
    String? cp,
    String? ville,
    String? password,
    List<Role>? roles,
    List<Association>? associations,
  }) {
    return User(
      id: id,
      profilePicURL: profilePicURL ?? this.profilePicURL,
      name: name ?? this.name,
      email: email ?? this.email,
      addressRue: addressRue ?? this.addressRue,
      cp: cp ?? this.cp,
      ville: ville ?? this.ville,
      password: password ?? this.password,
      roles: roles ?? this.roles,
      associations: associations ?? this.associations,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
