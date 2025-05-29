import 'package:acs_plugin/chat_models/communication_identifier/communication_identifier.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_thread_properties.freezed.dart';
part 'chat_thread_properties.g.dart';

@freezed
class ChatThreadProperties with _$ChatThreadProperties {
  const factory ChatThreadProperties({
    required String id,
    required String topic,
    required String createdOn,
    @JsonKey(name: 'createdBy', readValue: readValueObject)
    required CommunicationIdentifier createdBy,
    String? deletedOn,
  }) = _ChatThreadProperties;

  factory ChatThreadProperties.fromJson(Map<String, dynamic> json) =>
      _$ChatThreadPropertiesFromJson(json);
}
