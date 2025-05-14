import 'package:acs_plugin/chat_models/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/signaling_chat_thread_properties.dart';

class ChatThreadCreatedEvent {
  final String threadId;
  final String version;
  final String createdOn;
  final SignalingChatThreadProperties properties;
  final List<SignalingChatParticipant> participants;
  final SignalingChatParticipant createdBy;

  ChatThreadCreatedEvent({
    required this.threadId,
    required this.version,
    required this.createdOn,
    required this.properties,
    required this.participants,
    required this.createdBy,
  });

  factory ChatThreadCreatedEvent.fromJson(Map<String, dynamic> json) {
    return ChatThreadCreatedEvent(
      threadId: json['threadId'],
      version: json['version'],
      createdOn: json['createdOn'],
      properties: SignalingChatThreadProperties.fromJson(json['properties']),
      participants: (json['participants'] as List)
          .map((e) => SignalingChatParticipant.fromJson(e))
          .toList(),
      createdBy: SignalingChatParticipant.fromJson(json['createdBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'version': version,
      'createdOn': createdOn,
      'properties': properties.toJson(),
      'participants': participants.map((p) => p.toJson()).toList(),
      'createdBy': createdBy.toJson(),
    };
  }
}
