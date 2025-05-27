import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type/chat_message_type.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_messge_deleted_event.freezed.dart';
part 'chat_messge_deleted_event.g.dart';

@freezed
class ChatMessageDeletedEvent with _$ChatMessageDeletedEvent {
  const factory ChatMessageDeletedEvent({
    required String threadId,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    @JsonKey(name: 'recipient', readValue: readValueObject)
    CommunicationIdentifier? recipient,
    required String id,
    required String senderDisplayName,
    required String createdOn,
    required String version,
    required ChatMessageType type,
    String? deletedOn,
    Map<String, dynamic>? metadata,
  }) = _ChatMessageDeletedEvent;

  factory ChatMessageDeletedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDeletedEventFromJson(json);
}
