import 'package:acs_plugin/chat_models/communication_identifier.dart';

class TypingIndicatorReceivedEvent {
  final String threadId;
  final CommunicationIdentifier? sender;
  final CommunicationIdentifier? recipient;
  final String version;
  final String? receivedOn;
  final String? senderDisplayName;

  TypingIndicatorReceivedEvent({
    required this.threadId,
    this.sender,
    this.recipient,
    required this.version,
    this.receivedOn,
    this.senderDisplayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'sender': sender?.toJson(),
      'recipient': recipient?.toJson(),
      'version': version,
      'receivedOn': receivedOn,
      'senderDisplayName': senderDisplayName,
    };
  }

  static TypingIndicatorReceivedEvent fromJson(Map<String, dynamic> json) {
    return TypingIndicatorReceivedEvent(
      threadId: json['threadId'],
      sender: json['sender'] != null
          ? CommunicationIdentifier.fromJson(json['sender'])
          : null,
      recipient: json['recipient'] != null
          ? CommunicationIdentifier.fromJson(json['recipient'])
          : null,
      version: json['version'],
      receivedOn: json['receivedOn'],
      senderDisplayName: json['senderDisplayName'],
    );
  }
}
