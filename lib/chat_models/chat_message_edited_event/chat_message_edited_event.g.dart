// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_edited_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageEditedEventImpl _$$ChatMessageEditedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageEditedEventImpl(
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
      message: json['message'] as String,
      type: $enumDecodeNullable(_$ChatMessageTypeEnumMap, json['type']),
      editedOn: json['editedOn'] as String?,
      metadata: readValueObject(json, 'metadata') == null
          ? null
          : ChatMessageMetadata.fromJson(
              readValueObject(json, 'metadata') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatMessageEditedEventImplToJson(
        _$ChatMessageEditedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'id': instance.id,
      'senderDisplayName': instance.senderDisplayName,
      'createdOn': instance.createdOn,
      'version': instance.version,
      'message': instance.message,
      'type': _$ChatMessageTypeEnumMap[instance.type],
      'editedOn': instance.editedOn,
      'metadata': instance.metadata,
    };

const _$ChatMessageTypeEnumMap = {
  ChatMessageType.text: 'text',
  ChatMessageType.html: 'html',
  ChatMessageType.topicUpdated: 'topicUpdated',
  ChatMessageType.participantAdded: 'participantAdded',
  ChatMessageType.participantRemoved: 'participantRemoved',
  ChatMessageType.custom: 'custom',
  ChatMessageType.videoSessionStart: 'videoSessionStart',
};
