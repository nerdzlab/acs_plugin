import 'dart:async';

import 'package:acs_plugin/acs_plugin_error.dart';
import 'package:acs_plugin/chat_models/chat_message/chat_message.dart';
import 'package:acs_plugin/chat_models/chat_message_edited_event/chat_message_edited_event.dart';
import 'package:acs_plugin/chat_models/chat_message_read_receipt/chat_message_read_receipt.dart';
import 'package:acs_plugin/chat_models/chat_message_received_event/chat_message_received_event.dart';
import 'package:acs_plugin/chat_models/chat_message_type/chat_message_type.dart';
import 'package:acs_plugin/chat_models/chat_messge_deleted_event/chat_messge_deleted_event.dart';
import 'package:acs_plugin/chat_models/chat_participant/chat_participant.dart';
import 'package:acs_plugin/chat_models/chat_thread/chat_thread.dart';
import 'package:acs_plugin/chat_models/chat_thread_created_event/chat_thread_created_event.dart';
import 'package:acs_plugin/chat_models/chat_thread_deleted_event/chat_thread_deleted_event.dart';
import 'package:acs_plugin/chat_models/chat_thread_properties/chat_thread_properties.dart';
import 'package:acs_plugin/chat_models/chat_thread_properties_updated_event/chat_thread_properties_updated_event.dart';
import 'package:acs_plugin/chat_models/event/event.dart';
import 'package:acs_plugin/chat_models/event/event_type.dart';
import 'package:acs_plugin/chat_models/participants_added_event/participants_added_event.dart';
import 'package:acs_plugin/chat_models/participants_removed_event/participants_removed_event.dart';
import 'package:acs_plugin/chat_models/preloaded_action/preloaded_action.dart';
import 'package:acs_plugin/chat_models/push_notification_chat_message_received_event/push_notification_chat_message_received_event.dart';
import 'package:acs_plugin/chat_models/read_receipt_received_event/read_receipt_received_event.dart';
import 'package:acs_plugin/chat_models/typing_indicator_received_event/typing_indicator_received_event.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'acs_plugin_platform_interface.dart';
import 'dart:developer';

class AcsPlugin {
  StreamSubscription? _eventsSubscription;

  VoidCallback? onStopScreenShare;
  VoidCallback? onStartScreenShare;
  Function(String?)? onShowChat;
  VoidCallback? onCallUIClosed;
  VoidCallback? onPluginStarted;
  VoidCallback? onUserCallEnded;
  VoidCallback? onOneOnOneCallEnded;
  VoidCallback? onRealTimeNotificationConnected;
  VoidCallback? onRealTimeNotificationDisconnected;

  /// Called when native iOS needs a new token
  Future<String> Function()? onTokenRefreshRequested;

  Function(ChatMessageReceivedEvent)? onChatMessageReceived;
  Function(TypingIndicatorReceivedEvent)? onTypingIndicatorReceived;
  Function(ReadReceiptReceivedEvent)? onReadReceiptReceived;
  Function(ChatMessageEditedEvent)? onChatMessageEdited;
  Function(ChatMessageDeletedEvent)? onChatMessageDeleted;
  Function(ChatThreadCreatedEvent)? onChatThreadCreated;
  Function(ChatThreadPropertiesUpdatedEvent)? onChatThreadPropertiesUpdated;
  Function(ChatThreadDeletedEvent)? onChatThreadDeleted;
  Function(ParticipantsAddedEvent)? onParticipantsAdded;
  Function(ParticipantsRemovedEvent)? onParticipantsRemoved;
  Function(PushNotificationChatMessageReceivedEvent)?
      onChatPushNotificationOpened;
  Function(ACSPluginError error)? onError;

  init() {
    AcsPluginPlatform.instance.onTokenRefreshRequested =
        onTokenRefreshRequested;

    _eventsSubscription = eventStream.listen(
      (dynamic data) {
        final event = switch (data) {
          Map<String, dynamic> map => Event.fromMap(map),
          Map map => Event.fromMap(Map<String, dynamic>.from(map)),
          _ => Event(type: EventType.unknown, payload: data),
        };

        _handleEvent(event);
      },
      onError: _handleError,
      cancelOnError: false,
    );
  }

  dispose() {
    _eventsSubscription?.cancel();
  }

  // Initialize the room call
  Future<void> initializeRoomCall({
    required String roomId,
    required String callId,
    required bool isChatEnable,
    required String whiteBoardId,
    required bool isRejoin,
  }) async {
    await AcsPluginPlatform.instance.initializeRoomCall(
      roomId: roomId,
      callId: callId,
      whiteBoardId: whiteBoardId,
      isChatEnable: isChatEnable,
      isRejoin: isRejoin,
    );
  }

  // Start teams meeting call
  Future<void> startTeamsMeetingCall({
    required String meetingLink,
    required String callId,
    required String whiteBoardId,
    required bool isChatEnable,
    required bool isRejoin,
  }) async {
    await AcsPluginPlatform.instance.startTeamsMeetingCall(
      meetingLink: meetingLink,
      callId: callId,
      whiteBoardId: whiteBoardId,
      isChatEnable: isChatEnable,
      isRejoin: isRejoin,
    );
  }

  // Start one on one call
  Future<void> startOneOnOneCall({
    required List<String> participantsId,
  }) async {
    await AcsPluginPlatform.instance.startOneOnOneCall(
      participanstId: participantsId,
    );
  }

  // Set user data
  Future<void> setUserData({
    required String token,
    required String name,
    required String userId,
    required String languageCode,
    required String appToken,
    required String baseUrl,
  }) async {
    await AcsPluginPlatform.instance.setUserData(
      token: token,
      name: name,
      userId: userId,
      languageCode: languageCode,
      appToken: appToken,
      baseUrl: baseUrl,
    );
  }

  // Clear User Data
  Future<void> clearUserData() async {
    await AcsPluginPlatform.instance.clearUserData();
  }

// Sets the broadcast extension data for screen sharing on iOS.
  ///
  /// This is required to configure the screen broadcasting extension
  /// with the necessary app group and extension identifiers.
  ///
  /// This method is **iOS-only**.
  ///
  /// - [appGroupIdentifier]: The App Group identifier shared between the main app and the broadcast extension.
  /// - [extensionBubdleId]: The bundle ID of the broadcast upload extension.
  Future<void> setBroadcastExtensionData({
    required String appGroupIdentifier,
    required String extensionBubdleId,
  }) async {
    await AcsPluginPlatform.instance.setBroadcastExtensionData(
      appGroupIdentifier: appGroupIdentifier,
      extensionBubdleId: extensionBubdleId,
    );
  }

  // Need to show call ui
  Future<void> returnToCall() async {
    await AcsPluginPlatform.instance.returnToCall();
  }

  Future<void> setupChatService({
    required String endpoint,
  }) async {
    await AcsPluginPlatform.instance.setupChatService(
      endpoint: endpoint,
    );
  }

  Future<void> initChatThread({
    required String threadId,
  }) async {
    await AcsPluginPlatform.instance.initChatThread(
      threadId: threadId,
    );
  }

  Future<void> disconnectChatService() async {
    await AcsPluginPlatform.instance.disconnectChatService();
  }

  Future<void> unregisterPushNotifications() async {
    await AcsPluginPlatform.instance.unregisterPushNotifications();
  }

// Stream to listen for events
  Stream<Map<String, dynamic>> get eventStream {
    return AcsPluginPlatform.instance.eventStream;
  }

  _handleEvent(Event event) {
    switch (event.type) {
      case EventType.onStopScreenShare:
        log("Screen sharing stopped");
        onStopScreenShare?.call();
        break;
      case EventType.onStartScreenShare:
        log("Screen sharing started");
        onStartScreenShare?.call();
        break;
      case EventType.onShowChat:
        if (event.payload != null) {
          final azureCorrelationId = event.payload["azureCorrelationId"];
          onShowChat?.call(azureCorrelationId);
        } else {
          onShowChat?.call(null);
        }
        log("Show chat triggered");
        break;
      case EventType.onCallUIClosed:
        log("Call UI closed");
        onCallUIClosed?.call();
        break;
      case EventType.onPluginStarted:
        log("Plugin started");
        onPluginStarted?.call();
        break;
      case EventType.onUserCallEnded:
        log("User call ended");
        onUserCallEnded?.call();
        break;
      case EventType.onOneOnOneCallEnded:
        log("User one on one call ended");
        onOneOnOneCallEnded?.call();
        break;
      case EventType.onRealTimeNotificationConnected:
        log("Real-time notification connected");
        onRealTimeNotificationConnected?.call();
        break;
      case EventType.onRealTimeNotificationDisconnected:
        log("Real-time notification disconnected");
        onRealTimeNotificationDisconnected?.call();
        break;
      case EventType.onChatMessageReceived:
        log("Chat message received: ${event.payload}");
        if (event.payload != null) {
          final model = ChatMessageReceivedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatMessageReceived?.call(model);
        }
        break;
      case EventType.onTypingIndicatorReceived:
        log("Typing indicator received: ${event.payload}");
        if (event.payload != null) {
          final model = TypingIndicatorReceivedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onTypingIndicatorReceived?.call(model);
        }
        break;
      case EventType.onReadReceiptReceived:
        log("Read receipt received: ${event.payload}");
        if (event.payload != null) {
          final model = ReadReceiptReceivedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onReadReceiptReceived?.call(model);
        }
        break;
      case EventType.onChatMessageEdited:
        log("Chat message edited: ${event.payload}");
        if (event.payload != null) {
          final model = ChatMessageEditedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatMessageEdited?.call(model);
        }
        break;
      case EventType.onChatMessageDeleted:
        log("Chat message deleted: ${event.payload}");
        if (event.payload != null) {
          final model = ChatMessageDeletedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatMessageDeleted?.call(model);
        }
        break;
      case EventType.onChatThreadCreated:
        log("Chat thread created: ${event.payload}");
        if (event.payload != null) {
          final model = ChatThreadCreatedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatThreadCreated?.call(model);
        }
        break;
      case EventType.onChatThreadPropertiesUpdated:
        log("Chat thread properties updated: ${event.payload}");
        if (event.payload != null) {
          final model = ChatThreadPropertiesUpdatedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatThreadPropertiesUpdated?.call(model);
        }
        break;
      case EventType.onChatThreadDeleted:
        log("Chat thread deleted: ${event.payload}");
        if (event.payload != null) {
          final model = ChatThreadDeletedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatThreadDeleted?.call(model);
        }
        break;
      case EventType.onParticipantsAdded:
        log("Participants added: ${event.payload}");
        if (event.payload != null) {
          final model = ParticipantsAddedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onParticipantsAdded?.call(model);
        }
        break;
      case EventType.onParticipantsRemoved:
        log("Participants removed: ${event.payload}");
        if (event.payload != null) {
          final model = ParticipantsRemovedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onParticipantsRemoved?.call(model);
        }
        break;
      case EventType.onChatPushNotificationOpened:
        log("Chat push notification opened: ${event.payload}");
        if (event.payload != null) {
          final model = PushNotificationChatMessageReceivedEvent.fromJson(
              Map<String, dynamic>.from(event.payload));
          onChatPushNotificationOpened?.call(model);
        }
        break;
      case EventType.unknown:
        log("Unknown event: ${event.payload}");
        break;
    }
  }

  _handleError(dynamic error) {
    ACSPluginError acsError;

    if (error is PlatformException) {
      acsError = ACSPluginError(
        code: error.code,
        message: error.message,
        details: error.details,
      );
      log('Platform error: $acsError');
    } else {
      acsError = ACSPluginError(
        code: 'unknown',
        message: error.toString(),
        details: null,
      );
      log('Non-platform error: $acsError');
    }

    onError?.call(acsError);
  }

  Future<List<ChatParticipant>> getListOfParticipants({
    required String threadId,
  }) async {
    final result = await AcsPluginPlatform.instance
        .getListOfParticipants(threadId: threadId);
    return result
        .cast<Map>()
        .map((e) => ChatParticipant.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<ChatMessage>> getInitialMessages({
    required String threadId,
  }) async {
    final result =
        await AcsPluginPlatform.instance.getInitialMessages(threadId: threadId);

    return result.map(ChatMessage.fromJson).toList();
  }

  Future<ChatThreadProperties> retrieveChatThreadProperties({
    required String threadId,
  }) async {
    final result = await AcsPluginPlatform.instance
        .retrieveChatThreadProperties(threadId: threadId);
    return ChatThreadProperties.fromJson(result);
  }

  Future<List<ChatMessage>> getPreviousMessages({
    required String threadId,
  }) async {
    final result = await AcsPluginPlatform.instance
        .getPreviousMessages(threadId: threadId);
    return result
        .cast<Map>()
        .map((e) => ChatMessage.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<ChatMessageReadReceipt>> getListReadReceipts({
    required String threadId,
  }) async {
    final result = await AcsPluginPlatform.instance
        .getListReadReceipts(threadId: threadId);
    return result
        .cast<Map>()
        .map((e) =>
            ChatMessageReadReceipt.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<String?> sendMessage({
    required String threadId,
    required String content,
    required String senderDisplayName,
    ChatMessageType? type,
    Map<String, String>? metadata,
  }) async {
    final result = await AcsPluginPlatform.instance.sendMessage(
      threadId: threadId,
      content: content,
      senderDisplayName: senderDisplayName,
      type: type?.name,
      metadata: metadata,
    );

    return result;
  }

  Future<void> editMessage({
    required String threadId,
    required String messageId,
    required String content,
    Map<String, String>? metadata,
  }) async {
    await AcsPluginPlatform.instance.editMessage(
      threadId: threadId,
      messageId: messageId,
      content: content,
      metadata: metadata,
    );
  }

  Future<void> deleteMessage({
    required String threadId,
    required String messageId,
  }) async {
    await AcsPluginPlatform.instance.deleteMessage(
      threadId: threadId,
      messageId: messageId,
    );
  }

  Future<void> sendReadReceipt({
    required String threadId,
    required String messageId,
  }) async {
    await AcsPluginPlatform.instance.sendReadReceipt(
      threadId: threadId,
      messageId: messageId,
    );
  }

  Future<bool> isChatHasMoreMessages({
    required String threadId,
  }) async {
    final result = await AcsPluginPlatform.instance
        .isChatHasMoreMessages(threadId: threadId);
    return result;
  }

  Future<void> sendTypingIndicator({
    required String threadId,
  }) async {
    await AcsPluginPlatform.instance.sendTypingIndicator(threadId: threadId);
  }

  Future<PreloadedAction?> getPreloadedAction() async {
    final result = await AcsPluginPlatform.instance.getPreloadedAction();

    if (result == null) {
      return null;
    }

    return PreloadedAction.fromJson(result);
  }

  Future<ChatMessage?> getLastMessage({
    required String threadId,
  }) async {
    final result =
        await AcsPluginPlatform.instance.getLastMessage(threadId: threadId);

    if (result == null) {
      return null;
    }

    return ChatMessage.fromJson(result);
  }

  Future<List<ChatThread>> getInitialListThreads() async {
    final result = await AcsPluginPlatform.instance.getInitialListThreads();
    return result
        .cast<Map>()
        .map((e) => ChatThread.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<ChatThread>> getNextThreads() async {
    final result = await AcsPluginPlatform.instance.getNextThreads();
    return result
        .cast<Map>()
        .map((e) => ChatThread.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<bool> isMoreThreadsAvailable() async {
    final result = await AcsPluginPlatform.instance.isMoreThreadsAvailable();
    return result;
  }
}
