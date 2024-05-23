class Cat {
  final String name;
  final String birthDate;
  final String lastVaccineDate;
  final String lastVaccineName;
  final String color;
  final String behavior;
  final String race;
  final String description;
  final String sexe;
  final bool sterilized;
  final bool reserved;
  final String uploaded_file;

  Cat({
    required this.name,
    required this.birthDate,
    required this.lastVaccineDate,
    required this.lastVaccineName,
    required this.color,
    required this.behavior,
    required this.race,
    required this.description,
    required this.sexe,
    required this.sterilized,
    required this.reserved,
    required this.uploaded_file,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      name: json['name'],
      birthDate: json['birthDate'],
      lastVaccineDate: json['lastVaccineDate'],
      lastVaccineName: json['lastVaccineName'],
      color: json['color'],
      behavior: json['behavior'],
      race: json['race'],
      description: json['description'],
      sexe: json['sexe'],
      sterilized: json['sterilized'],
      reserved: json['reserved'],
      uploaded_file: json['uploaded_file']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'birthDate': birthDate,
      'lastVaccineDate': lastVaccineDate,
      'lastVaccineName': lastVaccineName,
      'color': color,
      'behavior': behavior,
      'race': race,
      'description': description,
      'sexe': sexe,
      'sterilized': sterilized,
      'reserved': reserved,
      'uploaded_file' : uploaded_file
    };
  }
}
