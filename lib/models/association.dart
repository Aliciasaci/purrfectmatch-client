class Association {
  final int? ID;
  final String Name;
  final String AddressRue;
  final String Cp;
  final String Ville;
  final String Phone;
  final String Email;
  final String kbisFile;
  final String OwnerID;
  List<String>? Members;
  final bool? Verified;
  final String? createdAt;
  final String? updatedAt;

  Association({
    this.ID,
    required this.Name,
    required this.AddressRue,
    required this.Cp,
    required this.Ville,
    required this.Phone,
    required this.Email,
    required this.kbisFile,
    required this.OwnerID,
    this.Members,
    this.Verified,
    this.createdAt,
    this.updatedAt,
  });

  factory Association.fromJson(Map<String, dynamic> json) {
    return Association(
      ID: json['ID'],
      Name: json['Name'] ?? '',
      AddressRue: json['AddressRue'] ?? '',
      Cp: json['Cp'] ?? '',
      Ville: json['Ville'] ?? '',
      Phone: json['Phone'] ?? '',
      Email: json['Email'] ?? '',
      kbisFile: json['KbisFile'] ?? '',
      OwnerID: json['OwnerID'] ?? '',
      Members: List<String>.from(json['Members'] ?? []),
      Verified: json['Verified'] ?? false,
      createdAt: json['CreatedAt'] ?? '',
      updatedAt: json['UpdatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': Name,
      'addressRue': AddressRue,
      'cp': Cp,
      'ville': Ville,
      'phone': Phone,
      'Email': Email,
      'kbisFile': kbisFile,
      'OwnerID': OwnerID,
      'members': Members ?? [],
      'verified': Verified,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };

    if (ID != null) data['id'] = ID;
    return data;
  }

  Association copyWith({
    int? ID,
    String? name,
    String? addressRue,
    String? cp,
    String? ville,
    String? phone,
    String? Email,
    String? kbisFile,
    String? OwnerID,
    List<String>? members,
    bool? verified,
    String? createdAt,
    String? updatedAt,
  }) {
    return Association(
      ID: ID ?? this.ID,
      Name: name ?? this.Name,
      AddressRue: addressRue ?? this.AddressRue,
      Cp: cp ?? this.Cp,
      Ville: ville ?? this.Ville,
      Phone: phone ?? this.Phone,
      Email: Email ?? this.Email,
      kbisFile: kbisFile ?? this.kbisFile,
      OwnerID: OwnerID ?? this.OwnerID,
      Members: members ?? this.Members,
      Verified: verified ?? this.Verified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
