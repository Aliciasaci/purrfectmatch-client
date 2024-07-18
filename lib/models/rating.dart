class Rating {
   int id;
   int mark;
   String comment;
   String userId;
   String authorId;

  Rating({
    required this.id,
    required this.mark,
    required this.comment,
    required this.userId,
    required this.authorId,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['ID'] ?? 0,
      mark: json['Mark'] ?? 0,
      comment: json['Comment'] ?? '',
      userId: json['UserID'] ?? '',
      authorId: json['AuthorID'] ?? '',
    );
  }

  set setMark(int mark) {
    this.mark = mark;
  }

  set setComment(String comment) {
    this.comment = comment;
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
