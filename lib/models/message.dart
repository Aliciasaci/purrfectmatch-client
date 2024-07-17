class Message {
  final int? id;
  final String? content;
  final String? senderId;
  final DateTime? timestamp;
  final bool? isRead;

  Message({
    this.id,
    this.content,
    this.senderId,
    this.timestamp,
    this.isRead,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['ID'],
      content: json['Content'],
      senderId: json['SenderID'],
      timestamp: DateTime.parse(json['CreatedAt']),
      isRead: json['IsRead'],
    );
  }

  factory Message.fromJsonLastest(Map<String, dynamic> json) {
    var parsedJson = json['message'];
    if (parsedJson == null) {
      return Message(
        id: null,
        content: null,
        senderId: null,
        timestamp: null,
        isRead: null,
      );
    } else {
      return Message.fromJson(parsedJson);
    }
  }
}
