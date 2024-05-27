class Annonce {
  final String Title;
  final String Description;
  final String? UserID;
  final String? CatID;

  Annonce({
    required this.Title,
    required this.Description,
    this.UserID,
    this.CatID,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      Title: json['Title'],
      Description: json['Description'],
      UserID: json['UserID'],
      CatID: json['CatID']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': Title,
      'Description': Description,
      'UserID': UserID,
      'CatID': CatID,
    };
  }

  @override
  String toString() {
    return '{Title: $Title, Description: $Description, UserID: $UserID, CatID: $CatID}';
  }
}
