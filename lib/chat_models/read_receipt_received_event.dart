import 'package:acs_plugin/chat_models/communication_identifier.dart';

class ReadReceiptReceivedEvent {
  final String threadId;
  final CommunicationIdentifier? sender;
  final CommunicationIdentifier? recipient;
  final String chatMessageId;
  final String? readOn;

  ReadReceiptReceivedEvent({
    required this.threadId,
    this.sender,
    this.recipient,
    required this.chatMessageId,
    this.readOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'sender': sender?.toJson(),
      'recipient': recipient?.toJson(),
      'chatMessageId': chatMessageId,
      'readOn': readOn,
    };
  }

  static ReadReceiptReceivedEvent fromJson(Map<String, dynamic> json) {
    return ReadReceiptReceivedEvent(
      threadId: json['threadId'],
      sender: json['sender'] != null
          ? CommunicationIdentifier.fromJson(json['sender'])
          : null,
      recipient: json['recipient'] != null
          ? CommunicationIdentifier.fromJson(json['recipient'])
          : null,
      chatMessageId: json['chatMessageId'],
      readOn: json['readOn'],
    );
  }
}
