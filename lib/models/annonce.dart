class Annonce {
  final String title;
  final String? description;
  final String UserID;

  Annonce({
    required this.title,
    this.description,
    required this.UserID,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      title: json['title'],
      description: json['description'],
      UserID : json['userID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'userID': UserID,
    };
  }
}
