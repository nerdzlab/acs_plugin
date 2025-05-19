// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageMetadataImpl _$$ChatMessageMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageMetadataImpl(
      attachments:
          (readValueListAndDecodeObjects(json, 'attachments') as List<dynamic>?)
              ?.map((e) => Attachments.fromJson(e as Map<String, dynamic>))
              .toList(),
      repliedTo: readValueAndDecodeObject(json, 'repliedTo') == null
          ? null
          : RepliedTo.fromJson(readValueAndDecodeObject(json, 'repliedTo')
              as Map<String, dynamic>),
      emojes: readValueAndDecodeObject(json, 'emojes') == null
          ? null
          : Emojes.fromJson(
              readValueAndDecodeObject(json, 'emojes') as Map<String, dynamic>),
      version: json['version'] as String?,
      isEdited: json['isEdited'] as bool?,
    );

Map<String, dynamic> _$$ChatMessageMetadataImplToJson(
        _$ChatMessageMetadataImpl instance) =>
    <String, dynamic>{
      'attachments': instance.attachments,
      'repliedTo': instance.repliedTo,
      'emojes': instance.emojes,
      'version': instance.version,
      'isEdited': instance.isEdited,
    };

_$AttachmentsImpl _$$AttachmentsImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentsImpl(
      name: json['name'] as String?,
      key: json['key'] as String?,
    );

Map<String, dynamic> _$$AttachmentsImplToJson(_$AttachmentsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'key': instance.key,
    };

_$RepliedToImpl _$$RepliedToImplFromJson(Map<String, dynamic> json) =>
    _$RepliedToImpl(
      id: json['id'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$RepliedToImplToJson(_$RepliedToImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
    };

_$EmojesImpl _$$EmojesImplFromJson(Map<String, dynamic> json) => _$EmojesImpl(
      like: (json['like'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$EmojesImplToJson(_$EmojesImpl instance) =>
    <String, dynamic>{
      'like': instance.like,
    };
