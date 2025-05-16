// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_indicator_received_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TypingIndicatorReceivedEventImpl _$$TypingIndicatorReceivedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$TypingIndicatorReceivedEventImpl(
      threadId: json['threadId'] as String,
      sender: readValueObject(json, 'sender') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'sender') as Map<String, dynamic>),
      recipient: readValueObject(json, 'recipient') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'recipient') as Map<String, dynamic>),
      version: json['version'] as String,
      receivedOn: json['receivedOn'] as String?,
      senderDisplayName: json['senderDisplayName'] as String?,
    );

Map<String, dynamic> _$$TypingIndicatorReceivedEventImplToJson(
        _$TypingIndicatorReceivedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'version': instance.version,
      'receivedOn': instance.receivedOn,
      'senderDisplayName': instance.senderDisplayName,
    };
