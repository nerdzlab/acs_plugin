// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_deleted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadDeletedEventImpl _$$ChatThreadDeletedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatThreadDeletedEventImpl(
      threadId: json['threadId'] as String,
      version: json['version'] as String,
      deletedOn: json['deletedOn'] as String,
      deletedBy: SignalingChatParticipant.fromJson(
          readValueObject(json, 'deletedBy') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatThreadDeletedEventImplToJson(
        _$ChatThreadDeletedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'version': instance.version,
      'deletedOn': instance.deletedOn,
      'deletedBy': instance.deletedBy,
    };
