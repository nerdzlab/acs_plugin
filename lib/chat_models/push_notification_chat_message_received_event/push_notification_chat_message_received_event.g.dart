// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification_chat_message_received_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PushNotificationChatMessageReceivedEventImpl
    _$$PushNotificationChatMessageReceivedEventImplFromJson(
            Map<String, dynamic> json) =>
        _$PushNotificationChatMessageReceivedEventImpl(
          messageId: json['messageId'] as String,
          type: json['type'] as String,
          threadId: json['threadId'] as String,
          sender: readValueObject(json, 'sender') == null
              ? null
              : CommunicationIdentifier.fromJson(
                  readValueObject(json, 'sender') as Map<String, dynamic>),
          recipient: readValueObject(json, 'recipient') == null
              ? null
              : CommunicationIdentifier.fromJson(
                  readValueObject(json, 'recipient') as Map<String, dynamic>),
          senderDisplayName: json['senderDisplayName'] as String?,
          originalArrivalTime: json['originalArrivalTime'] as String?,
          version: json['version'] as String,
          message: json['message'] as String,
          metadata: readValueObject(json, 'metadata') == null
              ? null
              : ChatMessageMetadata.fromJson(
                  readValueObject(json, 'metadata') as Map<String, dynamic>),
        );

Map<String, dynamic> _$$PushNotificationChatMessageReceivedEventImplToJson(
        _$PushNotificationChatMessageReceivedEventImpl instance) =>
    <String, dynamic>{
      'messageId': instance.messageId,
      'type': instance.type,
      'threadId': instance.threadId,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'senderDisplayName': instance.senderDisplayName,
      'originalArrivalTime': instance.originalArrivalTime,
      'version': instance.version,
      'message': instance.message,
      'metadata': instance.metadata,
    };
