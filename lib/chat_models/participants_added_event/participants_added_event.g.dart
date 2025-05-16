// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants_added_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantsAddedEventImpl _$$ParticipantsAddedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ParticipantsAddedEventImpl(
      threadId: json['threadId'] as String,
      version: json['version'] as String,
      addedOn: json['addedOn'] as String,
      participantsAdded:
          (readValueListObjects(json, 'participantsAdded') as List<dynamic>)
              .map((e) =>
                  SignalingChatParticipant.fromJson(e as Map<String, dynamic>))
              .toList(),
      addedBy: SignalingChatParticipant.fromJson(
          readValueObject(json, 'addedBy') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ParticipantsAddedEventImplToJson(
        _$ParticipantsAddedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'version': instance.version,
      'addedOn': instance.addedOn,
      'participantsAdded': instance.participantsAdded,
      'addedBy': instance.addedBy,
    };
