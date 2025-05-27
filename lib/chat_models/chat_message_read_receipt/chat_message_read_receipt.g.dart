// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_read_receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatMessageReadReceiptImpl _$$ChatMessageReadReceiptImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatMessageReadReceiptImpl(
      sender: readValueObject(json, 'sender') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'sender') as Map<String, dynamic>),
      chatMessageId: json['chatMessageId'] as String,
      readOn: json['readOn'] as String,
    );

Map<String, dynamic> _$$ChatMessageReadReceiptImplToJson(
        _$ChatMessageReadReceiptImpl instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'chatMessageId': instance.chatMessageId,
      'readOn': instance.readOn,
    };
