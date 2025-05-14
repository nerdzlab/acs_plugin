import 'package:acs_plugin/chat_models/signaling_chat_participant.dart';

class ParticipantsRemovedEvent {
  final String threadId;
  final String version;
  final String removedOn;
  final List<SignalingChatParticipant> participantsRemoved;
  final SignalingChatParticipant removedBy;

  ParticipantsRemovedEvent({
    required this.threadId,
    required this.version,
    required this.removedOn,
    required this.participantsRemoved,
    required this.removedBy,
  });

  factory ParticipantsRemovedEvent.fromJson(Map<String, dynamic> json) {
    return ParticipantsRemovedEvent(
      threadId: json['threadId'],
      version: json['version'],
      removedOn: json['removedOn'],
      participantsRemoved: (json['participantsRemoved'] as List)
          .map((e) => SignalingChatParticipant.fromJson(e))
          .toList(),
      removedBy: SignalingChatParticipant.fromJson(json['removedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'version': version,
      'removedOn': removedOn,
      'participantsRemoved':
          participantsRemoved.map((e) => e.toJson()).toList(),
      'removedBy': removedBy.toJson(),
    };
  }
}
