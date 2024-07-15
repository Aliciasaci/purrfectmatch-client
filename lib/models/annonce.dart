class Annonce {
  final int? ID;
  final String Title;
  final String Description;
  final String? UserID;
  final String CatID;

  Annonce({
    this.ID,
    required this.Title,
    required this.Description,
    this.UserID,
    required this.CatID,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      ID: json['ID'],
      Title: json['Title'] ?? '',
      Description: json['Description'] ?? '',
      UserID: json['UserID'] ?? '',
      CatID: json['CatID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'Title': Title,
      'Description': Description,
      'CatID': CatID,
    };

    if (UserID != null) {
      data['UserID'] = UserID;
    }

    return data;
  }

  Annonce copyWith({
    int? ID,
    String? Title,
    String? Description,
    String? UserID,
    String? CatID,
  }) {
    return Annonce(
      ID: ID ?? this.ID,
      Title: Title ?? this.Title,
      Description: Description ?? this.Description,
      UserID: UserID ?? this.UserID,
      CatID: CatID ?? this.CatID,
    );
  }

  @override
  String toString() {
    return 'ID: $ID, Title: $Title, Description: $Description, UserID: $UserID, CatID: $CatID}';
  }
}
