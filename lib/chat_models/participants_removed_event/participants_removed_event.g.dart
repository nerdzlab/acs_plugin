// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participants_removed_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ParticipantsRemovedEventImpl _$$ParticipantsRemovedEventImplFromJson(
        Map<String, dynamic> json) =>
    _$ParticipantsRemovedEventImpl(
      threadId: json['threadId'] as String,
      version: json['version'] as String,
      removedOn: json['removedOn'] as String,
      participantsRemoved:
          (readValueListObjects(json, 'participantsAdded') as List<dynamic>)
              .map((e) =>
                  SignalingChatParticipant.fromJson(e as Map<String, dynamic>))
              .toList(),
      removedBy: SignalingChatParticipant.fromJson(
          readValueObject(json, 'removedBy') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ParticipantsRemovedEventImplToJson(
        _$ParticipantsRemovedEventImpl instance) =>
    <String, dynamic>{
      'threadId': instance.threadId,
      'version': instance.version,
      'removedOn': instance.removedOn,
      'participantsAdded': instance.participantsRemoved,
      'removedBy': instance.removedBy,
    };
