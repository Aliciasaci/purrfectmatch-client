class Annonce {
  final String title;
  final String description;
  final String catId;

  Annonce({
    required this.title,
    required this.description,
    required this.catId,
  });

  factory Annonce.fromJson(Map<String, dynamic> json) {
    return Annonce(
      title: json['title'],
      description: json['description'],
      catId: json['catId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'catId': catId,
    };
  }

  @override
  String toString() {
    return 'Annonce{title: $title, description: $description, catId: $catId}';
  }
}
