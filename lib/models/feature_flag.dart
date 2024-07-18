class FeatureFlag {
  final int? id;
  final String name;
  final bool isEnabled;


  FeatureFlag({
    this.id,
    required this.name,
    this.isEnabled = true,
  });

  factory FeatureFlag.fromJson(Map<String, dynamic> json) {
    return FeatureFlag(
        id: json['ID'],
        name: json['Name'],
        isEnabled: json['IsEnabled']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isEnabled': isEnabled
    };
  }

  FeatureFlag copyWith({
    int? id,
    String? name,
    bool? isEnabled,
  }) {
    return FeatureFlag(
      id: id ?? this.id,
      name: name ?? this.name,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  String toString() {
    return '{ID: $id, Name: $name, IsEnabled: $isEnabled}';
  }
}
