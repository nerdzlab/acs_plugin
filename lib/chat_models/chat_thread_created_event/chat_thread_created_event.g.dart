// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_created_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadCreatedEventImpl _$$ChatThreadCreatedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatThreadCreatedEventImpl(
      threadId: json['threadId'] as String,
      version: json['version'] as String,
      createdOn: json['createdOn'] as String,
      properties: SignalingChatThreadProperties.fromJson(
          readValueObject(json, 'properties') as Map<String, dynamic>),
      participants:
          (readValueListObjects(json, 'participants') as List<dynamic>)
              .map((e) =>
                  SignalingChatParticipant.fromJson(e as Map<String, dynamic>))
              .toList(),
      createdBy: SignalingChatParticipant.fromJson(
          readValueObject(json, 'createdBy') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatThreadCreatedEventImplToJson(
        _$ChatThreadCreatedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'version': instance.version,
      'createdOn': instance.createdOn,
      'properties': instance.properties,
      'participants': instance.participants,
      'createdBy': instance.createdBy,
    };
