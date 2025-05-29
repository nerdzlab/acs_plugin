import 'package:freezed_annotation/freezed_annotation.dart';

part 'signaling_chat_thread_properties.freezed.dart';
part 'signaling_chat_thread_properties.g.dart';

@freezed
class SignalingChatThreadProperties with _$SignalingChatThreadProperties {
  const factory SignalingChatThreadProperties({
    required String topic,
  }) = _SignalingChatThreadProperties;

  factory SignalingChatThreadProperties.fromJson(Map<String, dynamic> json) =>
      _$SignalingChatThreadPropertiesFromJson(json);
}
