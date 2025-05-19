import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_metadata.freezed.dart';
part 'chat_message_metadata.g.dart';

@freezed
class ChatMessageMetadata with _$ChatMessageMetadata {
  const factory ChatMessageMetadata({
    @JsonKey(name: 'repliedTo', readValue: readValueAndDecodeObject)
    RepliedTo? repliedTo,
    @JsonKey(name: 'emojes', readValue: readValueAndDecodeObject)
    Emojes? emojes,
    String? version,
    @JsonKey(
        name: 'fileSharingMetadata', readValue: readValueListAndDecodeObjects)
    List<Attachments>? attachments,
    bool? isEdited,
  }) = _ChatMessageMetadata;

  factory ChatMessageMetadata.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageMetadataFromJson(json);
}

@freezed
class Attachments with _$Attachments {
  const factory Attachments({
    String? id,
    String? name,
    String? url,
  }) = _Attachments;

  factory Attachments.fromJson(Map<String, dynamic> json) =>
      _$AttachmentsFromJson(json);
}

@freezed
class RepliedTo with _$RepliedTo {
  const factory RepliedTo({
    String? id,
    String? text,
  }) = _RepliedTo;

  factory RepliedTo.fromJson(Map<String, dynamic> json) =>
      _$RepliedToFromJson(json);
}

@freezed
class Emojes with _$Emojes {
  const factory Emojes({
    List<String>? like,
  }) = _Emojes;

  factory Emojes.fromJson(Map<String, dynamic> json) => _$EmojesFromJson(json);
}
