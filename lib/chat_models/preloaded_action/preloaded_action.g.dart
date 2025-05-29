// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preloaded_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PreloadedActionImpl _$$PreloadedActionImplFromJson(
        Map<String, dynamic> json) =>
    _$PreloadedActionImpl(
      type: $enumDecode(_$PreloadedActionTypeEnumMap, json['type']),
      chatPushNotificationReceivedEvent:
          readValueObject(json, 'chatPushNotificationReceivedEvent') == null
              ? null
              : PushNotificationChatMessageReceivedEvent.fromJson(
                  readValueObject(json, 'chatPushNotificationReceivedEvent')
                      as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PreloadedActionImplToJson(
        _$PreloadedActionImpl instance) =>
    <String, dynamic>{
      'type': _$PreloadedActionTypeEnumMap[instance.type]!,
      'chatPushNotificationReceivedEvent':
          instance.chatPushNotificationReceivedEvent,
    };

const _$PreloadedActionTypeEnumMap = {
  PreloadedActionType.chatNotification: 'chatNotification',
};
