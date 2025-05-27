// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_thread_properties_updated_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatThreadPropertiesUpdatedEventImpl
    _$$ChatThreadPropertiesUpdatedEventImplFromJson(
            Map<String, dynamic> json) =>
        _$ChatThreadPropertiesUpdatedEventImpl(
          threadId: json['threadId'] as String,
          version: json['version'] as String,
          updatedOn: json['updatedOn'] as String,
          properties: SignalingChatThreadProperties.fromJson(
              readValueObject(json, 'properties') as Map<String, dynamic>),
          updatedBy: SignalingChatParticipant.fromJson(
              readValueObject(json, 'updatedBy') as Map<String, dynamic>),
        );

Map<String, dynamic> _$$ChatThreadPropertiesUpdatedEventImplToJson(
        _$ChatThreadPropertiesUpdatedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'version': instance.version,
      'updatedOn': instance.updatedOn,
      'properties': instance.properties,
      'updatedBy': instance.updatedBy,
    };
