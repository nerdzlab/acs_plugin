import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'typing_indicator_received_event.freezed.dart';
part 'typing_indicator_received_event.g.dart';

@freezed
class TypingIndicatorReceivedEvent with _$TypingIndicatorReceivedEvent {
  const factory TypingIndicatorReceivedEvent({
    required String threadId,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    @JsonKey(name: 'recipient', readValue: readValueObject)
    CommunicationIdentifier? recipient,
    required String version,
    String? receivedOn,
    String? senderDisplayName,
  }) = _TypingIndicatorReceivedEvent;

  factory TypingIndicatorReceivedEvent.fromJson(Map<String, dynamic> json) =>
      _$TypingIndicatorReceivedEventFromJson(json);
}
