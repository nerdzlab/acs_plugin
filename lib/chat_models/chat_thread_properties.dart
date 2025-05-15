import 'package:acs_plugin/chat_models/communication_identifier.dart';

class ChatThreadProperties {
  final String id;
  final String topic;
  final DateTime createdOn;
  final CommunicationIdentifier createdBy;
  final DateTime? deletedOn;

  ChatThreadProperties({
    required this.id,
    required this.topic,
    required this.createdOn,
    required this.createdBy,
    this.deletedOn,
  });

  factory ChatThreadProperties.fromJson(Map<String, dynamic> json) {
    return ChatThreadProperties(
      id: json['id'] as String,
      topic: json['topic'] as String,
      createdOn: DateTime.parse(json['createdOn'] as String),
      createdBy: CommunicationIdentifier.fromJson(
          json['createdBy'] as Map<String, dynamic>),
      deletedOn: json['deletedOn'] != null
          ? DateTime.parse(json['deletedOn'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'createdOn': createdOn.toIso8601String(),
      'createdBy': createdBy.toJson(),
      if (deletedOn != null) 'deletedOn': deletedOn!.toIso8601String(),
    };
  }
}
