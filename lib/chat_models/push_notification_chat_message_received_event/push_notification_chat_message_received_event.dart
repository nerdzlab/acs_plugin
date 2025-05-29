import 'package:acs_plugin/chat_models/chat_message_metadata/chat_message_metadata.dart';
import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification_chat_message_received_event.freezed.dart';
part 'push_notification_chat_message_received_event.g.dart';

@freezed
class PushNotificationChatMessageReceivedEvent
    with _$PushNotificationChatMessageReceivedEvent {
  const factory PushNotificationChatMessageReceivedEvent({
    required String messageId,
    required String type,
    required String threadId,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    @JsonKey(name: 'recipient', readValue: readValueObject)
    CommunicationIdentifier? recipient,
    String? senderDisplayName,
    String? originalArrivalTime,
    required String version,
    required String message,
    @JsonKey(name: 'metadata', readValue: readValueObject)
    ChatMessageMetadata? metadata,
  }) = _PushNotificationChatMessageReceivedEvent;

  factory PushNotificationChatMessageReceivedEvent.fromJson(
          Map<String, dynamic> json) =>
      _$PushNotificationChatMessageReceivedEventFromJson(json);
}
