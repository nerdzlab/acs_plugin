// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatParticipantImpl _$$ChatParticipantImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatParticipantImpl(
      id: CommunicationIdentifier.fromJson(
          readValueObject(json, 'id') as Map<String, dynamic>),
      displayName: json['displayName'] as String?,
      shareHistoryTime: json['shareHistoryTime'] as String?,
    );

Map<String, dynamic> _$$ChatParticipantImplToJson(
        _$ChatParticipantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'shareHistoryTime': instance.shareHistoryTime,
    };
