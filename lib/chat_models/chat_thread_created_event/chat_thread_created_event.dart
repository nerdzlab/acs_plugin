import 'package:acs_plugin/chat_models/signaling_chat_participant/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/signaling_chat_thread_properties/signaling_chat_thread_properties.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_thread_created_event.freezed.dart';
part 'chat_thread_created_event.g.dart';

@freezed
class ChatThreadCreatedEvent with _$ChatThreadCreatedEvent {
  const factory ChatThreadCreatedEvent({
    required String threadId,
    required String version,
    required String createdOn,
    @JsonKey(name: 'properties', readValue: readValueObject)
    required SignalingChatThreadProperties properties,
    @JsonKey(name: 'participants', readValue: readValueListObjects)
    required List<SignalingChatParticipant> participants,
    @JsonKey(name: 'createdBy', readValue: readValueObject)
    required SignalingChatParticipant createdBy,
  }) = _ChatThreadCreatedEvent;

  factory ChatThreadCreatedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadCreatedEventFromJson(json);
}
