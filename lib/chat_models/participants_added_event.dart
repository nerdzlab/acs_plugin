import 'package:acs_plugin/chat_models/signaling_chat_participant.dart';

class ParticipantsAddedEvent {
  final String threadId;
  final String version;
  final String addedOn;
  final List<SignalingChatParticipant> participantsAdded;
  final SignalingChatParticipant addedBy;

  ParticipantsAddedEvent({
    required this.threadId,
    required this.version,
    required this.addedOn,
    required this.participantsAdded,
    required this.addedBy,
  });

  factory ParticipantsAddedEvent.fromJson(Map<String, dynamic> json) {
    return ParticipantsAddedEvent(
      threadId: json['threadId'],
      version: json['version'],
      addedOn: json['addedOn'],
      participantsAdded: (json['participantsAdded'] as List)
          .map((e) => SignalingChatParticipant.fromJson(e))
          .toList(),
      addedBy: SignalingChatParticipant.fromJson(json['addedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'version': version,
      'addedOn': addedOn,
      'participantsAdded': participantsAdded.map((e) => e.toJson()).toList(),
      'addedBy': addedBy.toJson(),
    };
  }
}
