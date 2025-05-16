import 'package:acs_plugin/chat_models/identifier_kind/identifier_kind.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'communication_identifier.freezed.dart';
part 'communication_identifier.g.dart';

@freezed
class CommunicationIdentifier with _$CommunicationIdentifier {
  const factory CommunicationIdentifier({
    required String rawId,
    @JsonKey(name: 'kind', readValue: readValueObject)
    required IdentifierKind kind,
  }) = _CommunicationIdentifier;

  factory CommunicationIdentifier.fromJson(Map<String, dynamic> json) =>
      _$CommunicationIdentifierFromJson(json);
}
