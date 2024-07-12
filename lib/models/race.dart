class Races {
  final int id;
  final String raceName;
  final String? cats;

  Races({
    required this.id,
    required this.raceName,
    this.cats
  });

  factory Races.fromJson(Map<String, dynamic> json) {
    return Races(
      id : json['ID'],
      raceName: json['RaceName'],
      cats: json['Cats'] ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'raceName' : raceName
    };
  }

  @override
  String toString() {
    return '{ID: $id, RaceName: $raceName}';
  }
}
