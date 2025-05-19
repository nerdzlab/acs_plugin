// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageImpl _$$ChatMessageImplFromJson(Map<String, dynamic> json) =>
    _$ChatMessageImpl(
      id: json['id'] as String,
      sequenceId: json['sequenceId'] as String,
      version: json['version'] as String,
      type: $enumDecode(_$ChatMessageTypeEnumMap, json['type']),
      createdOn: json['createdOn'] as String,
      content: readValueObject(json, 'content') == null
          ? null
          : ChatMessageContent.fromJson(
              readValueObject(json, 'content') as Map<String, dynamic>),
      sender: readValueObject(json, 'sender') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'sender') as Map<String, dynamic>),
      senderDisplayName: json['senderDisplayName'] as String?,
      editedOn: json['editedOn'] as String?,
      deletedOn: json['deletedOn'] as String?,
      metadata: readValueObject(json, 'metadata') as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatMessageImplToJson(_$ChatMessageImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequenceId': instance.sequenceId,
      'version': instance.version,
      'type': _$ChatMessageTypeEnumMap[instance.type]!,
      'createdOn': instance.createdOn,
      'content': instance.content,
      'sender': instance.sender,
      'senderDisplayName': instance.senderDisplayName,
      'editedOn': instance.editedOn,
      'deletedOn': instance.deletedOn,
      'metadata': instance.metadata,
    };

const _$ChatMessageTypeEnumMap = {
  ChatMessageType.text: 'text',
  ChatMessageType.html: 'html',
  ChatMessageType.topicUpdated: 'topicUpdated',
  ChatMessageType.participantAdded: 'participantAdded',
  ChatMessageType.participantRemoved: 'participantRemoved',
  ChatMessageType.custom: 'custom',
};
