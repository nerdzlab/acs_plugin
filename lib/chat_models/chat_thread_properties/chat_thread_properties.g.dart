// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_properties.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadPropertiesImpl _$$ChatThreadPropertiesImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatThreadPropertiesImpl(
      id: json['id'] as String,
      topic: json['topic'] as String,
      createdOn: json['createdOn'] as String,
      createdBy: CommunicationIdentifier.fromJson(
          readValueObject(json, 'createdBy') as Map<String, dynamic>),
      deletedOn: json['deletedOn'] as String?,
    );

Map<String, dynamic> _$$ChatThreadPropertiesImplToJson(
        _$ChatThreadPropertiesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'topic': instance.topic,
      'createdOn': instance.createdOn,
      'createdBy': instance.createdBy,
      'deletedOn': instance.deletedOn,
    };
