import 'package:acs_plugin/chat_models/communication_identifier.dart';

class ChatMessageDeletedEvent {
  final String threadId;
  final CommunicationIdentifier? sender;
  final CommunicationIdentifier? recipient;
  final String id;
  final String senderDisplayName;
  final String createdOn;
  final String version;
  final String type;
  final String? deletedOn;

  ChatMessageDeletedEvent({
    required this.threadId,
    this.sender,
    this.recipient,
    required this.id,
    required this.senderDisplayName,
    required this.createdOn,
    required this.version,
    required this.type,
    this.deletedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'sender': sender?.toJson(),
      'recipient': recipient?.toJson(),
      'id': id,
      'senderDisplayName': senderDisplayName,
      'createdOn': createdOn,
      'version': version,
      'type': type,
      'deletedOn': deletedOn,
    };
  }

  static ChatMessageDeletedEvent fromJson(Map<String, dynamic> json) {
    return ChatMessageDeletedEvent(
      threadId: json['threadId'],
      sender: json['sender'] != null
          ? CommunicationIdentifier.fromJson(json['sender'])
          : null,
      recipient: json['recipient'] != null
          ? CommunicationIdentifier.fromJson(json['recipient'])
          : null,
      id: json['id'],
      senderDisplayName: json['senderDisplayName'],
      createdOn: json['createdOn'],
      version: json['version'],
      type: json['type'],
      deletedOn: json['deletedOn'],
    );
  }
}
