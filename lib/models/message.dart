class Message {
  final int? id;
  final String content;
  final String senderId;
  final DateTime timestamp;

  Message({
    this.id,
    required this.content,
    required this.senderId,
    required this.timestamp,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['ID'],
      content: json['Content'],
      senderId: json['SenderID'],
      timestamp: DateTime.parse(json['CreatedAt']),
    );
  }
}
