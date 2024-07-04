class Role {
  final int? id;
  final String name;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Role({
    this.id,
    required this.name,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['ID'],
      name: json['Name'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      deletedAt: json['DeletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'DeletedAt': deletedAt,
    };
  }
}