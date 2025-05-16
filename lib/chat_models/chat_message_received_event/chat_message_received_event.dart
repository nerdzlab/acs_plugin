import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/chat_message_type/chat_message_type.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_received_event.freezed.dart';
part 'chat_message_received_event.g.dart';

@freezed
class ChatMessageReceivedEvent with _$ChatMessageReceivedEvent {
  const factory ChatMessageReceivedEvent({
    required String threadId,
    required String id,
    required String message,
    required String version,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    @JsonKey(name: 'recipient', readValue: readValueObject)
    CommunicationIdentifier? recipient,
    String? senderDisplayName,
    String? createdOn,
    required ChatMessageType type,
    Map<String, dynamic>? metadata,
  }) = _ChatMessageReceivedEvent;

  factory ChatMessageReceivedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageReceivedEventFromJson(json);
}
