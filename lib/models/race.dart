class Race {
  final int? id;
  final String raceName;
  final String? cats;

  Race({
    this.id,
    required this.raceName,
    this.cats
  });

  factory Race.fromJson(Map<String, dynamic> json) {
    return Race(
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
