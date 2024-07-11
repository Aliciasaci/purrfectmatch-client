class Room {
  final String? id;
  final String user1Id;
  final String user2Id;
  final int? annonceID;
  final String? annonceTitle;

  Room({
    this.id,
    required this.user1Id,
    required this.user2Id,
    this.annonceID,
    this.annonceTitle,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['ID'],
      user1Id: json['User1ID'],
      user2Id: json['User2ID'],
    );
  }

  factory Room.fromModifiedJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'],
      user1Id: json['user1ID'],
      user2Id: json['user2ID'],
      annonceID: json['annonceID'],
      annonceTitle: json['annonceTitle'],
    );
  }
}
