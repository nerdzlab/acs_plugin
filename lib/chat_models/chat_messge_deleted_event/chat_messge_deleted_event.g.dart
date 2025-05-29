// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_messge_deleted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageDeletedEventImpl _$$ChatMessageDeletedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageDeletedEventImpl(
      threadId: json['threadId'] as String,
      sender: readValueObject(json, 'sender') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'sender') as Map<String, dynamic>),
      recipient: readValueObject(json, 'recipient') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'recipient') as Map<String, dynamic>),
      id: json['id'] as String,
      senderDisplayName: json['senderDisplayName'] as String,
      createdOn: json['createdOn'] as String,
      version: json['version'] as String,
      type: $enumDecode(_$ChatMessageTypeEnumMap, json['type']),
      deletedOn: json['deletedOn'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatMessageDeletedEventImplToJson(
        _$ChatMessageDeletedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'id': instance.id,
      'senderDisplayName': instance.senderDisplayName,
      'createdOn': instance.createdOn,
      'version': instance.version,
      'type': _$ChatMessageTypeEnumMap[instance.type]!,
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
