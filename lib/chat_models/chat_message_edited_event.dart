import 'package:acs_plugin/chat_models/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type.dart';

class ChatMessageEditedEvent {
  final String threadId;
  final CommunicationIdentifier? sender;
  final CommunicationIdentifier? recipient;
  final String id;
  final String senderDisplayName;
  final String createdOn;
  final String version;
  final ChatMessageType type;
  final String message;
  final String? editedOn;
  final Map<String, dynamic>? metadata;

  ChatMessageEditedEvent({
    required this.threadId,
    this.sender,
    this.recipient,
    required this.id,
    required this.senderDisplayName,
    required this.createdOn,
    required this.version,
    required this.type,
    required this.message,
    this.editedOn,
    this.metadata,
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
      'type': type.toJson(),
      'message': message,
      'editedOn': editedOn,
      'metadata': metadata,
    };
  }

  static ChatMessageEditedEvent fromJson(Map<String, dynamic> json) {
    return ChatMessageEditedEvent(
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
      type: ChatMessageType.fromString(json['type']),
      message: json['message'],
      editedOn: json['editedOn'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }
}
