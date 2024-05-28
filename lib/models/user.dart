class User {
  final String email;
  final String name;
  final String adresse;
  final String city;

  User({
    required this.email,
    required this.name,
    required this.adresse,
    required this.city,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      adresse: json['adresse'] ?? '',
      city: json['city'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'adresse': adresse,
      'city': city,
    };
  }
}
