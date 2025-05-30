import 'package:acs_plugin/chat_models/signaling_chat_participant/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/signaling_chat_thread_properties/signaling_chat_thread_properties.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_thread_properties_updated_event.freezed.dart';
part 'chat_thread_properties_updated_event.g.dart';

@freezed
class ChatThreadPropertiesUpdatedEvent with _$ChatThreadPropertiesUpdatedEvent {
  const factory ChatThreadPropertiesUpdatedEvent({
    required String threadId,
    required String version,
    required String updatedOn,
    @JsonKey(name: 'properties', readValue: readValueObject)
    required SignalingChatThreadProperties properties,
    @JsonKey(name: 'updatedBy', readValue: readValueObject)
    required SignalingChatParticipant updatedBy,
  }) = _ChatThreadPropertiesUpdatedEvent;

  factory ChatThreadPropertiesUpdatedEvent.fromJson(
          Map<String, dynamic> json) =>
      _$ChatThreadPropertiesUpdatedEventFromJson(json);
}
