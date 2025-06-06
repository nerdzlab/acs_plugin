import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum ChatMessageType {
  @JsonValue('text')
  text,
  @JsonValue('html')
  html,
  @JsonValue('topicUpdated')
  topicUpdated,
  @JsonValue('participantAdded')
  participantAdded,
  @JsonValue('participantRemoved')
  participantRemoved,
  @JsonValue('custom')
  custom,
  @JsonValue('videoSessionStart')
  videoSessionStart,
}
