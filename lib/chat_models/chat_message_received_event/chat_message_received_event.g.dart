// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_received_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageReceivedEventImpl _$$ChatMessageReceivedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageReceivedEventImpl(
      threadId: json['threadId'] as String,
      id: json['id'] as String,
      message: json['message'] as String,
      version: json['version'] as String,
      sender: readValueObject(json, 'sender') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'sender') as Map<String, dynamic>),
      recipient: readValueObject(json, 'recipient') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'recipient') as Map<String, dynamic>),
      senderDisplayName: json['senderDisplayName'] as String?,
      createdOn: json['createdOn'] as String?,
      type: $enumDecode(_$ChatMessageTypeEnumMap, json['type']),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ChatMessageReceivedEventImplToJson(
        _$ChatMessageReceivedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'id': instance.id,
      'message': instance.message,
      'version': instance.version,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'senderDisplayName': instance.senderDisplayName,
      'createdOn': instance.createdOn,
      'type': _$ChatMessageTypeEnumMap[instance.type]!,
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
