class Annonce {
  final String Title;
  final String Description;
  final String CatID;

  Annonce({
    required this.Title,
    required this.Description,
    required this.CatID,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    final annonceJson = json['annonce'] ?? {};
    return Annonce(
      Title: annonceJson['Title'] ?? '',
      Description: annonceJson['Description'] ?? '',
      CatID: annonceJson['CatID'].toString(),  // Convertir en String si nécessaire
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': Title,
      'Description': Description,
      'CatID': CatID,
    };
  }

  @override
  String toString() {
    return '{title: $Title, description: $Description, catId: $CatID}';
  }
}
