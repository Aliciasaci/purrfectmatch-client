class Cat {
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
      name: json['Name'],
      birthDate: json['BirthDate'],
      sexe: json['Sexe'],
      lastVaccineDate: json['LastVaccineDate'] ?? '',
      lastVaccineName: json['LastVaccineName'] ?? '',
      color: json['Color'],
      behavior: json['Behavior'],
      sterilized: json['Sterilized'],
      race: json['Race'],
      description: json['Description'] ?? '',
      reserved: json['Reserved'],
      picturesUrl: List<String>.from(json['PicturesURL'] ?? []),
    );
  }
}
