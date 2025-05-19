import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_read_receipt.freezed.dart';
part 'chat_message_read_receipt.g.dart';

@freezed
class ChatMessageReadReceipt with _$ChatMessageReadReceipt {
  const factory ChatMessageReadReceipt({
    @JsonKey(name: 'sender', readValue: readValueObject)
    CommunicationIdentifier? sender,
    required String chatMessageId,
    required String readOn,
  }) = _ChatMessageReadReceipt;

  factory ChatMessageReadReceipt.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageReadReceiptFromJson(json);
}
