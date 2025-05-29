// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_identifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommunicationIdentifierImpl _$$CommunicationIdentifierImplFromJson(
        Map<String, dynamic> json) =>
    _$CommunicationIdentifierImpl(
      rawId: json['rawId'] as String,
      kind: IdentifierKind.fromJson(
          readValueObject(json, 'kind') as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommunicationIdentifierImplToJson(
        _$CommunicationIdentifierImpl instance) =>
    <String, dynamic>{
      'rawId': instance.rawId,
      'kind': instance.kind,
    };
