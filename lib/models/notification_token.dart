class NotificationToken {
  final int? id;
  final String userId;
  final String token;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  NotificationToken({
    this.id,
    required this.userId,
    required this.token,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory NotificationToken.fromJson(Map<String, dynamic> json) {
    return NotificationToken(
      id: json['ID'],
      userId: json['UserID'],
      token: json['Token'],
      createdAt: json['CreatedAt'],
      updatedAt: json['UpdatedAt'],
      deletedAt: json['DeletedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'token': token,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
      'DeletedAt': deletedAt,
    };
  }
}