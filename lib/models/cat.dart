class Cat {
  final int? ID;
  final String name;
  final String birthDate;
  final String sexe;
  final String lastVaccineDate;
  final String lastVaccineName;
  final String color;
  final String behavior;
  final bool sterilized;
  final String race;
  final String description;
  final bool reserved;
  final List<String> picturesUrl;

  Cat({
    this.ID,
    required this.name,
    required this.birthDate,
    required this.sexe,
    required this.lastVaccineDate,
    required this.lastVaccineName,
    required this.color,
    required this.behavior,
    required this.sterilized,
    required this.race,
    required this.description,
    required this.reserved,
    required this.picturesUrl,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      ID : json['ID'],
      name: json['Name'],
      birthDate: json['BirthDate'],
      sexe: json['Sexe'],
      lastVaccineDate: json['LastVaccine'] ?? '',
      lastVaccineName: json['LastVaccineName'] ?? '',
      color: json['Color'],
      behavior: json['Behavior'],
      sterilized: json['Sterilized'],
      race: json['RaceID'],
      description: json['Description'] ?? '',
      reserved: json['Reserved'],
      picturesUrl: List<String>.from(json['PicturesURL'] ?? []),
    );
  }
}
