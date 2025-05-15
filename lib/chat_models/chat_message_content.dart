class ChatMessageContent {
  final String? message;
  final String? displayMessage;

  ChatMessageContent({
    this.message,
    this.displayMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'displayMessage': displayMessage,
    };
  }

  factory ChatMessageContent.fromJson(Map<String, dynamic> json) {
    return ChatMessageContent(
      message: json['message'],
      displayMessage: json['displayMessage'],
    );
  }
}
