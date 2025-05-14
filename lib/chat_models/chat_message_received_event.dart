import 'package:acs_plugin/chat_models/communication_identifier.dart';

class ChatMessageReceivedEvent {
  final String threadId;
  final String id;
  final String message;
  final String version;
  final CommunicationIdentifier? sender;
  final CommunicationIdentifier? recipient;
  final String? senderDisplayName;
  final String? createdOn;
  final String type;
  final Map<String, dynamic>? metadata;

  ChatMessageReceivedEvent({
    required this.threadId,
    required this.id,
    required this.message,
    required this.version,
    this.sender,
    this.recipient,
    this.senderDisplayName,
    this.createdOn,
    required this.type,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'threadId': threadId,
      'id': id,
      'message': message,
      'version': version,
      'sender': sender?.toJson(),
      'recipient': recipient?.toJson(),
      'senderDisplayName': senderDisplayName,
      'createdOn': createdOn,
      'type': type,
      'metadata': metadata,
    };
  }

  static ChatMessageReceivedEvent fromJson(Map<String, dynamic> json) {
    return ChatMessageReceivedEvent(
      threadId: json['threadId'],
      id: json['id'],
      message: json['message'],
      version: json['version'],
      sender: json['sender'] != null
          ? CommunicationIdentifier.fromJson(json['sender'])
          : null,
      recipient: json['recipient'] != null
          ? CommunicationIdentifier.fromJson(json['recipient'])
          : null,
      senderDisplayName: json['senderDisplayName'],
      createdOn: json['createdOn'],
      type: json['type'],
      metadata: json['metadata'],
    );
  }
}
