class Favoris {
  final int? ID;
  final String UserID;
  final String AnnonceID;

  Favoris({
    this.ID,
    required this.UserID,
    required this.AnnonceID,
  });

  factory Favoris.fromJson(Map<String, dynamic> json) {
    return Favoris(
      ID : json['ID'],
        UserID: json['UserID'],
      AnnonceID: json['AnnonceID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID' : ID,
      'UserID': UserID,
      'AnnonceID' : AnnonceID,
    };
  }

  @override
  String toString() {
    return '{ID: $ID, Title: $UserID, Description: $AnnonceID}';
  }
}
