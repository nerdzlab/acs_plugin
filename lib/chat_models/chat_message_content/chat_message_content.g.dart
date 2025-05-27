// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageContentImpl _$$ChatMessageContentImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageContentImpl(
      message: json['message'] as String?,
      topic: json['topic'] as String?,
      participants:
          (readValueListObjects(json, 'participants') as List<dynamic>?)
              ?.map((e) => ChatParticipant.fromJson(e as Map<String, dynamic>))
              .toList(),
      initiator: readValueObject(json, 'initiator') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'initiator') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatMessageContentImplToJson(
        _$ChatMessageContentImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'topic': instance.topic,
      'participants': instance.participants,
      'initiator': instance.initiator,
    };
