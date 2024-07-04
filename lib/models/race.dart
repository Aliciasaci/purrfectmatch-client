class Races {
  final int ID;
  final String raceName;

  Races({
    required this.ID,
    required this.raceName
  });

  factory Races.fromJson(Map<String, dynamic> json) {
    return Races(
      ID : json['ID'],
      raceName: json['raceName']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID' : ID,
      'RaceName' : raceName
    };
  }

  @override
  String toString() {
    return '{ID: $ID, RaceName: $raceName}';
  }
}
