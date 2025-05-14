import 'package:acs_plugin/chat_models/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/signaling_chat_thread_properties.dart';

class ChatThreadPropertiesUpdatedEvent {
  final String threadId;
  final String version;
  final String updatedOn;
  final SignalingChatThreadProperties properties;
  final SignalingChatParticipant updatedBy;

  ChatThreadPropertiesUpdatedEvent({
    required this.threadId,
    required this.version,
    required this.updatedOn,
    required this.properties,
    required this.updatedBy,
  });

  factory ChatThreadPropertiesUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return ChatThreadPropertiesUpdatedEvent(
      threadId: json['threadId'],
      version: json['version'],
      updatedOn: json['updatedOn'],
      properties: SignalingChatThreadProperties.fromJson(json['properties']),
      updatedBy: SignalingChatParticipant.fromJson(json['updatedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'version': version,
      'updatedOn': updatedOn,
      'properties': properties.toJson(),
      'updatedBy': updatedBy.toJson(),
    };
  }
}
