// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_receipt_received_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReadReceiptReceivedEventImpl _$$ReadReceiptReceivedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ReadReceiptReceivedEventImpl(
      threadId: json['threadId'] as String,
      sender: readValueObject(json, 'sender') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'sender') as Map<String, dynamic>),
      recipient: readValueObject(json, 'recipient') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'recipient') as Map<String, dynamic>),
      chatMessageId: json['chatMessageId'] as String,
      readOn: json['readOn'] as String?,
    );

Map<String, dynamic> _$$ReadReceiptReceivedEventImplToJson(
        _$ReadReceiptReceivedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'chatMessageId': instance.chatMessageId,
      'readOn': instance.readOn,
    };
