class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime timestamp;
  final MessageType messageType;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.timestamp,
    required this.messageType,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isMe': isMe,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'messageType': messageType.toString(),
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'],
      isMe: json['isMe'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      messageType: MessageType.values.firstWhere(
        (e) => e.toString() == json['messageType'],
        orElse: () => MessageType.text,
      ),
    );
  }
}

enum MessageType { text, image, location }