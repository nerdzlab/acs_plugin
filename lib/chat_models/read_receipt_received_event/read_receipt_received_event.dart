import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'read_receipt_received_event.freezed.dart';
part 'read_receipt_received_event.g.dart';

@freezed
class ReadReceiptReceivedEvent with _$ReadReceiptReceivedEvent {
  const factory ReadReceiptReceivedEvent({
    required String threadId,
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    @JsonKey(name: 'recipient', readValue: readValueObject)
    CommunicationIdentifier? recipient,
    required String chatMessageId,
    String? readOn,
  }) = _ReadReceiptReceivedEvent;

  factory ReadReceiptReceivedEvent.fromJson(Map<String, dynamic> json) =>
      _$ReadReceiptReceivedEventFromJson(json);
}
