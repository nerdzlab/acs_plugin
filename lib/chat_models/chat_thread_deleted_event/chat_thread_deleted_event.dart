import 'package:acs_plugin/chat_models/signaling_chat_participant/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_thread_deleted_event.freezed.dart';
part 'chat_thread_deleted_event.g.dart';

@freezed
class ChatThreadDeletedEvent with _$ChatThreadDeletedEvent {
  const factory ChatThreadDeletedEvent({
    required String threadId,
    required String version,
    required String deletedOn,
    @JsonKey(name: 'deletedBy', readValue: readValueObject)
    required SignalingChatParticipant deletedBy,
  }) = _ChatThreadDeletedEvent;

  factory ChatThreadDeletedEvent.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadDeletedEventFromJson(json);
}
