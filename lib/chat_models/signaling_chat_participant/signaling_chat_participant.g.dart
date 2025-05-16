// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signaling_chat_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SignalingChatParticipantImpl _$$SignalingChatParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$SignalingChatParticipantImpl(
      id: readValueObject(json, 'id') == null
          ? null
          : CommunicationIdentifier.fromJson(
              readValueObject(json, 'id') as Map<String, dynamic>),
      displayName: json['displayName'] as String?,
      shareHistoryTime: json['shareHistoryTime'] as String?,
    );

Map<String, dynamic> _$$SignalingChatParticipantImplToJson(
        _$SignalingChatParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'shareHistoryTime': instance.shareHistoryTime,
    };
