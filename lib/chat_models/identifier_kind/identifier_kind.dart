import 'package:freezed_annotation/freezed_annotation.dart';

part 'identifier_kind.freezed.dart';
part 'identifier_kind.g.dart';

@freezed
class IdentifierKind with _$IdentifierKind {
  const factory IdentifierKind({
    required String rawValue,
  }) = _IdentifierKind;

  factory IdentifierKind.fromJson(Map<String, dynamic> json) =>
      _$IdentifierKindFromJson(json);

  static const communicationUser =
      IdentifierKind(rawValue: 'communicationUser');
  static const phoneNumber = IdentifierKind(rawValue: 'phoneNumber');
  static const microsoftTeamsUser =
      IdentifierKind(rawValue: 'microsoftTeamsUser');
  static const microsoftTeamsApp =
      IdentifierKind(rawValue: 'microsoftTeamsApp');
  static const unknown = IdentifierKind(rawValue: 'unknown');
}
