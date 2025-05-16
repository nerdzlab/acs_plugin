import 'package:acs_plugin/chat_models/signaling_chat_participant/signaling_chat_participant.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'participants_added_event.freezed.dart';
part 'participants_added_event.g.dart';

@freezed
class ParticipantsAddedEvent with _$ParticipantsAddedEvent {
  const factory ParticipantsAddedEvent({
    required String threadId,
    required String version,
    required String addedOn,
    @JsonKey(name: 'participantsAdded', readValue: readValueListObjects)
    required List<SignalingChatParticipant> participantsAdded,
    @JsonKey(name: 'addedBy', readValue: readValueObject)
    required SignalingChatParticipant addedBy,
  }) = _ParticipantsAddedEvent;

  factory ParticipantsAddedEvent.fromJson(Map<String, dynamic> json) =>
      _$ParticipantsAddedEventFromJson(json);
}
