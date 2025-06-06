import 'package:json_annotation/json_annotation.dart';

part 'event_type.g.dart';

@JsonEnum(alwaysCreate: true)
enum EventType {
  onStopScreenShare,
  onStartScreenShare,
  onShowChat,
  onCallUIClosed,
  onPluginStarted,
  onUserCallEnded,
  onOneOnOneCallEnded,
  onRealTimeNotificationConnected,
  onRealTimeNotificationDisconnected,
  onChatMessageReceived,
  onTypingIndicatorReceived,
  onReadReceiptReceived,
  onChatMessageEdited,
  onChatMessageDeleted,
  onChatThreadCreated,
  onChatThreadPropertiesUpdated,
  onChatThreadDeleted,
  onParticipantsAdded,
  onParticipantsRemoved,
  onChatPushNotificationOpened,
  unknown,
}
