// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadImpl _$$ChatThreadImplFromJson(Map<String, dynamic> json) =>
    _$ChatThreadImpl(
      id: json['id'] as String,
      topic: json['topic'] as String,
      deletedOn: json['deletedOn'] as String?,
      lastMessageReceivedOn: json['lastMessageReceivedOn'] as String?,
    );

Map<String, dynamic> _$$ChatThreadImplToJson(_$ChatThreadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'deletedOn': instance.deletedOn,
      'lastMessageReceivedOn': instance.lastMessageReceivedOn,
    };
