class User {
  final String email;
  final String password;
  final String name;
  final String adresse;
  final String city;

  User({required this.email, required this.password, required this.name, required this.adresse, required this.city});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['username'],
      password: json['token'],
      name: json['name'],
      adresse: json['adresse'],
      city: json['city']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name' : name,
      'adresse' : adresse,
      'city' : city
    };
  }
}