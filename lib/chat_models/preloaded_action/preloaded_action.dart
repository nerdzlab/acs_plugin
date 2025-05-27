import 'package:acs_plugin/chat_models/push_notification_chat_message_received_event/push_notification_chat_message_received_event.dart';
import 'package:acs_plugin/chat_models/utilities/map_helpers.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'preloaded_action.freezed.dart';
part 'preloaded_action.g.dart';

/// Dart equivalent of the Swift enum PreloadedActionType
enum PreloadedActionType {
  @JsonValue('chatNotification')
  chatNotification,
}

@freezed
class PreloadedAction with _$PreloadedAction {
  const factory PreloadedAction({
    required PreloadedActionType type,
    @JsonKey(
        name: 'chatPushNotificationReceivedEvent', readValue: readValueObject)
    PushNotificationChatMessageReceivedEvent? chatPushNotificationReceivedEvent,
  }) = _PreloadedAction;

  factory PreloadedAction.fromJson(Map<String, dynamic> json) =>
      _$PreloadedActionFromJson(json);
}
