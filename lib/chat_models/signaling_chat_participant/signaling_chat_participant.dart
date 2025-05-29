import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'signaling_chat_participant.freezed.dart';
part 'signaling_chat_participant.g.dart';

@freezed
class SignalingChatParticipant with _$SignalingChatParticipant {
  const factory SignalingChatParticipant({
    @JsonKey(name: 'id', readValue: readValueObject)
    CommunicationIdentifier? id,
    String? displayName,
    String? shareHistoryTime,
  }) = _SignalingChatParticipant;

  factory SignalingChatParticipant.fromJson(Map<String, dynamic> json) =>
      _$SignalingChatParticipantFromJson(json);
}
