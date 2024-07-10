class Rating {
  final int id;
  final int mark;
  final String comment;
  final String userId;
  final String authorId;

  Rating({
    required this.id,
    required this.mark,
    required this.comment,
    required this.userId,
    required this.authorId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['ID'],
      mark: json['Mark'],
      comment: json['Comment'],
      userId: json['UserID'],
      authorId: json['AuthorID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Mark': mark,
      'Comment': comment,
      'UserID': userId,
      'AuthorID': authorId,
    };
  }
}
