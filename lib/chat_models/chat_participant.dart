import 'package:acs_plugin/chat_models/communication_identifier.dart';

class ChatParticipant {
  final String id;
  final String displayName;
  final CommunicationIdentifier? identifier;
  final bool? isMuted;

  ChatParticipant({
    required this.id,
    required this.displayName,
    this.identifier,
    this.isMuted,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'identifier': identifier?.toJson(),
      'isMuted': isMuted,
    };
  }

  factory ChatParticipant.fromJson(Map<String, dynamic> json) {
    return ChatParticipant(
      id: json['id'],
      displayName: json['displayName'],
      identifier: json['identifier'] != null
          ? CommunicationIdentifier.fromJson(json['identifier'])
          : null,
      isMuted: json['isMuted'],
    );
  }
}
