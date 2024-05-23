class Cat {
  final String name;
  final String sexe;
  final String birthDate;
  final String lastVaccineDate;
  final String lastVaccineName;
  final String color;
  final String behavior;
  final String race;
  final String description;
  final String gender;
  final bool sterilized;
  final bool reserved;

  Cat({
    required this.name,
    required this.sexe,
    required this.birthDate,
    required this.lastVaccineDate,
    required this.lastVaccineName,
    required this.color,
    required this.behavior,
    required this.race,
    required this.description,
    required this.gender,
    required this.sterilized,
    required this.reserved,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      sexe: json['sexe'],
      birthDate: json['birthDate'],
      lastVaccineDate: json['lastVaccineDate'],
      lastVaccineName: json['lastVaccineName'],
      color: json['color'],
      behavior: json['behavior'],
      race: json['race'],
      description: json['description'],
      gender: json['gender'],
      sterilized: json['sterilized'],
      reserved: json['reserved'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'sexe' : sexe,
      'birthDate': birthDate,
      'lastVaccineDate': lastVaccineDate,
      'lastVaccineName': lastVaccineName,
      'color': color,
      'behavior': behavior,
      'race': race,
      'description': description,
      'gender': gender,
      'sterilized': sterilized,
      'reserved': reserved,
    };
  }
}
