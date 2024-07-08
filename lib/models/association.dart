import 'package:purrfectmatch/models/user.dart';

class Association {
  final String name;
  final String addressRue;
  final String cp;
  final String ville;
  final String phone;
  final String email;
  final String kbisFile;
  final String ownerId;
  final bool? verified;
  final String? createdAt;
  final String? updatedAt;

  Association({
    required this.name,
    required this.addressRue,
    required this.cp,
    required this.ville,
    required this.phone,
    required this.email,
    required this.kbisFile,
    required this.ownerId,
    this.verified,
    this.createdAt,
    this.updatedAt,
  });

  factory Association.fromJson(Map<String, dynamic> json) {
    List<User> membersList = [];
    if (json['members'] != null) {
      membersList = List<User>.from(json['members'].map((member) => User.fromJson(member)));
    }

    return Association(
      name: json['Name'] ?? '',
      addressRue: json['AddressRue'] ?? '',
      cp: json['Cp'] ?? '',
      ville: json['Ville'] ?? '',
      phone: json['Phone'] ?? '',
      email: json['Email'] ?? '',
      kbisFile: json['KbisFile'] ?? '',
      ownerId: json['OwnerId'] ?? '',
      verified: json['Verified'] ?? false,
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']).toIso8601String() : null,
      updatedAt: json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']).toIso8601String() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'addressRue': addressRue,
      'cp': cp,
      'ville': ville,
      'phone': phone,
      'email': email,
      'ownerId': ownerId,
    };

    if (verified != null) data['verified'] = verified.toString();
    if (createdAt != null) data['createdAt'] = createdAt!;
    if (updatedAt != null) data['updatedAt'] = updatedAt!;

    return data;
  }

  @override
  String toString() {
    return 'Association { name: $name, addressRue: $addressRue, cp: $cp, ville: $ville, phone: $phone, email: $email, kbisFile: $kbisFile, ownerId: $ownerId, verified: $verified, createdAt: $createdAt, updatedAt: $updatedAt }';
  }
}