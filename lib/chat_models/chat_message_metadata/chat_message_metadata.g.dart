// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageMetadataImpl _$$ChatMessageMetadataImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageMetadataImpl(
      attachments: readValueObject(json, 'attachments') == null
          ? null
          : Attachments.fromJson(
              readValueObject(json, 'attachments') as Map<String, dynamic>),
      repliedTo: readValueObject(json, 'repliedTo') == null
          ? null
          : RepliedTo.fromJson(
              readValueObject(json, 'repliedTo') as Map<String, dynamic>),
      emojes: readValueObject(json, 'emojes') == null
          ? null
          : Emojes.fromJson(
              readValueObject(json, 'emojes') as Map<String, dynamic>),
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
      key: json['key'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AttachmentsImplToJson(_$AttachmentsImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'count': instance.count,
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
