import 'package:purrfectmatch/models/user.dart';

class Association {
  final int? id;
  final String name;
  final String addressRue;
  final String cp;
  final String ville;
  final String phone;
  final String email;
  final String kbisFile;
  final String ownerId;
  // final User? owner;
  final bool? verified;
  final String? createdAt;
  final String? updatedAt;

  Association({
    this.id,
    required this.name,
    required this.addressRue,
    required this.cp,
    required this.ville,
    required this.phone,
    required this.email,
    required this.kbisFile,
    required this.ownerId,
    // this.owner,
    this.verified,
    this.createdAt,
    this.updatedAt,
  });

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      id: json['ID'],
      name: json['Name'] ?? '',
      addressRue: json['AddressRue'] ?? '',
      cp: json['Cp'] ?? '',
      ville: json['Ville'] ?? '',
      phone: json['Phone'] ?? '',
      email: json['Email'] ?? '',
      kbisFile: json['KbisFile'] ?? '',
      ownerId: json['OwnerId'] ?? '',
      // owner: json['owner'] != null ? User.fromJson(json['owner']) : null,
      verified: json['Rerified'] ?? false,
      createdAt: json['CreatedAt'] != null ? DateTime.parse(json['CreatedAt']).toIso8601String() : null,
      updatedAt: json['UpdatedAt'] != null ? DateTime.parse(json['UpdatedAt']).toIso8601String() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'addressRue': addressRue,
      'cp': cp,
      'ville': ville,
      'phone': phone,
      'email': email,
      'kbisFile': kbisFile,
      'ownerId': ownerId,
      //'owner': owner?.toJson(),
    };

    if (id != null) data['id'] = id;
    if (verified != null) data['verified'] = verified;
    if (createdAt != null) data['createdAt'] = createdAt;
    if (updatedAt != null) data['updatedAt'] = updatedAt;

    return data;
  }

  Association copyWith({
    int? id,
    String? name,
    String? addressRue,
    String? cp,
    String? ville,
    String? phone,
    String? email,
    String? kbisFile,
    String? ownerId,
    // User? owner,
    bool? verified,
    String? createdAt,
    String? updatedAt,
  }) {
    return Association(
      id: id ?? this.id,
      name: name ?? this.name,
      addressRue: addressRue ?? this.addressRue,
      cp: cp ?? this.cp,
      ville: ville ?? this.ville,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      kbisFile: kbisFile ?? this.kbisFile,
      ownerId: ownerId ?? this.ownerId,
      // owner: owner ?? this.owner,
      verified: verified ?? this.verified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Association { id: $id, name: $name, addressRue: $addressRue, cp: $cp, ville: $ville, phone: $phone, email: $email, kbisFile: $kbisFile, ownerId: $ownerId, verified: $verified, createdAt: $createdAt, updatedAt: $updatedAt }';
  }
}
