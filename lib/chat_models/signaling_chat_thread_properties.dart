class SignalingChatThreadProperties {
  final String topic;

  SignalingChatThreadProperties({required this.topic});

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
    };
  }

  static SignalingChatThreadProperties fromJson(Map<String, dynamic> json) {
    return SignalingChatThreadProperties(
      topic: json['topic'],
    );
  }
}
