import 'package:acs_plugin/chat_models/signaling_chat_participant.dart';

class ChatThreadDeletedEvent {
  final String threadId;
  final String version;
  final String deletedOn;
  final SignalingChatParticipant deletedBy;

  ChatThreadDeletedEvent({
    required this.threadId,
    required this.version,
    required this.deletedOn,
    required this.deletedBy,
  });

  factory ChatThreadDeletedEvent.fromJson(Map<String, dynamic> json) {
    return ChatThreadDeletedEvent(
      threadId: json['threadId'],
      version: json['version'],
      deletedOn: json['deletedOn'],
      deletedBy: SignalingChatParticipant.fromJson(json['deletedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'version': version,
      'deletedOn': deletedOn,
      'deletedBy': deletedBy.toJson(),
    };
  }
}
