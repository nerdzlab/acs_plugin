import 'package:acs_plugin/chat_models/chat_message/chat_message.dart';
import 'package:acs_plugin/chat_models/chat_participant/chat_participant.dart';
import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_content.freezed.dart';
part 'chat_message_content.g.dart';

@freezed
class ChatMessageContent with _$ChatMessageContent {
  const factory ChatMessageContent({
    String? message,
    String? topic,
    @JsonKey(name: 'participants', readValue: readValueListObjects)
    List<ChatParticipant>? participants,
    @JsonKey(name: 'initiator', readValue: readValueObject)
    CommunicationIdentifier? initiator,
  }) = _ChatMessageContent;

  factory ChatMessageContent.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageContentFromJson(json);
}
