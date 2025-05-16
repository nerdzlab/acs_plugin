import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type/chat_message_type.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import '../chat_message_content/chat_message_content.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

@freezed
class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required String sequenceId,
    required String version,
    required ChatMessageType type,
    required String createdOn,
    @JsonKey(name: 'content', readValue: readValueObject)
    ChatMessageContent? content,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    String? senderDisplayName,
    String? editedOn,
    String? deletedOn,
    Map<String, dynamic>? metadata,
  }) = _ChatMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}
