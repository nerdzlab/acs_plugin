import 'package:acs_plugin/chat_models/communication_identifier.dart';

class SignalingChatParticipant {
  final CommunicationIdentifier? id;
  final String? displayName;
  final String? shareHistoryTime;

  SignalingChatParticipant({
    this.id,
    this.displayName,
    this.shareHistoryTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toJson(),
      'displayName': displayName,
      'shareHistoryTime': shareHistoryTime,
    };
  }

  static SignalingChatParticipant fromJson(Map<String, dynamic> json) {
    return SignalingChatParticipant(
      id: json['id'] != null
          ? CommunicationIdentifier.fromJson(json['id'])
          : null,
      displayName: json['displayName'],
      shareHistoryTime: json['shareHistoryTime'],
    );
  }
}
