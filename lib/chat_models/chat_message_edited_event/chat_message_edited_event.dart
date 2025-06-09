import 'package:acs_plugin/chat_models/chat_message_metadata/chat_message_metadata.dart';
import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type/chat_message_type.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_edited_event.freezed.dart';
part 'chat_message_edited_event.g.dart';

@freezed
class ChatMessageEditedEvent with _$ChatMessageEditedEvent {
  const factory ChatMessageEditedEvent({
    required String threadId,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    @JsonKey(name: 'recipient', readValue: readValueObject)
    CommunicationIdentifier? recipient,
    required String id,
    required String senderDisplayName,
    required String createdOn,
    required String version,
    required String message,
    ChatMessageType? type,
    String? editedOn,
    @JsonKey(name: 'metadata', readValue: readValueObject)
    ChatMessageMetadata? metadata,
  }) = _ChatMessageEditedEvent;

  factory ChatMessageEditedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageEditedEventFromJson(json);
}
