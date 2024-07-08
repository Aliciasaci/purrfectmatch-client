import 'package:purrfectmatch/models/user.dart';

class Association {
  final String name;
  final String addressRue;
  final String cp;
  final String ville;
  final String phone;
  final String email;
  final String kbisFile;
  final List<User> members;
  final String ownerId;
  final User owner;
  final bool verified;
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
    this.members = const [],
    required this.ownerId,
    required this.owner,
    required this.verified,
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
      members: membersList,
      ownerId: json['OwnerId'] ?? '',
      owner: User.fromJson(json['Owner']),
      verified: json['Verified'] ?? false,
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']).toIso8601String() : null,
      updatedAt: json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']).toIso8601String() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'addressRue': addressRue,
      'cp': cp,
      'ville': ville,
      'phone': phone,
      'email': email,
      'kbisFile': kbisFile,
      'members': members.map((member) => member.toJson()).toList(),
      'ownerId': ownerId,
      'owner': owner.toJson(),
      'verified': verified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override
  String toString() {
    return 'Association { name: $name, addressRue: $addressRue, cp: $cp, ville: $ville, phone: $phone, email: $email, kbisFile: $kbisFile, members: $members, ownerId: $ownerId, owner: $owner, verified: $verified, createdAt: $createdAt, updatedAt: $updatedAt }';
  }
}