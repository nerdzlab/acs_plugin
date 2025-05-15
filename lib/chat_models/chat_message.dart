import 'package:acs_plugin/chat_models/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type.dart';
import 'chat_message_content.dart'; // import the content class above

class ChatMessage {
  final String id;
  final String threadId;
  final CommunicationIdentifier? sender;
  final String senderDisplayName;
  final String createdOn;
  final ChatMessageType type;
  final ChatMessageContent content;
  final String? editedOn;
  final Map<String, dynamic>? metadata;

  ChatMessage({
    required this.id,
    required this.threadId,
    this.sender,
    required this.senderDisplayName,
    required this.createdOn,
    required this.type,
    required this.content,
    this.editedOn,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'threadId': threadId,
      'sender': sender?.toJson(),
      'senderDisplayName': senderDisplayName,
      'createdOn': createdOn,
      'type': type.toJson(),
      'content': content.toJson(),
      'editedOn': editedOn,
      'metadata': metadata,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      threadId: json['threadId'],
      sender: json['sender'] != null
          ? CommunicationIdentifier.fromJson(json['sender'])
          : null,
      senderDisplayName: json['senderDisplayName'],
      createdOn: json['createdOn'],
      type: ChatMessageType.fromString(json['type']),
      content: ChatMessageContent.fromJson(json['content']),
      editedOn: json['editedOn'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }
}
