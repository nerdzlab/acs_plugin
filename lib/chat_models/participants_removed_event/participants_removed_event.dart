import 'package:acs_plugin/chat_models/signaling_chat_participant/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participants_removed_event.freezed.dart';
part 'participants_removed_event.g.dart';

@freezed
class ParticipantsRemovedEvent with _$ParticipantsRemovedEvent {
  const factory ParticipantsRemovedEvent({
    required String threadId,
    required String version,
    required String removedOn,
    @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
    required List<SignalingChatParticipant> participantsRemoved,
    @JsonKey(name: 'removedBy', readValue: readValueObject)
    required SignalingChatParticipant removedBy,
  }) = _ParticipantsRemovedEvent;

  factory ParticipantsRemovedEvent.fromJson(Map<String, dynamic> json) =>
      _$ParticipantsRemovedEventFromJson(json);
}
