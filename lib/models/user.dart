class User {
  final String id;
  final String name;
  final String email;
  final String addressRue;
  final String cp;
  final String ville;
  final String? password;
  final String? profilePicURL;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.addressRue,
    required this.cp,
    required this.ville,
    this.password,
    this.profilePicURL,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['ID'],
      createdAt: DateTime.parse(json['CreatedAt']).toIso8601String(),
      updatedAt: DateTime.parse(json['UpdatedAt']).toIso8601String(),
      name: json['Name'],
      email: json['Email'],
      password: json['Password'],
      addressRue: json['AddressRue'],
      cp: json['Cp'],
      ville: json['Ville'],
      profilePicURL: json['ProfilePicURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'addressRue': addressRue,
      'cp': cp,
      'ville': ville,
      'password': password,
      'profilePicURL': profilePicURL,
      'createdAt': createdAt,
    };
  }

  @override
  String toString() {
    return '{name: $name, email: $email, addressRue: $addressRue, cp: $cp, ville: $ville, password: $password, profilePicURL: $profilePicURL, createdAt: $createdAt}';
  }


}
