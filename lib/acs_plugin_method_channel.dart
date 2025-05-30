import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'acs_plugin_platform_interface.dart';

/// An implementation of [AcsPluginPlatform] that uses method channels.
class MethodChannelAcsPlugin extends AcsPluginPlatform {
  MethodChannelAcsPlugin() {
    methodChannel.setMethodCallHandler(_handleNativeMethodCall);
  }

  @visibleForTesting
  final methodChannel = const MethodChannel('acs_plugin');

  @visibleForTesting
  final eventChannel = const EventChannel('acs_plugin_events');

  Stream<Map<String, dynamic>>? _eventStream;

  @override
  Stream<Map<String, dynamic>> get eventStream {
    _eventStream ??= eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
          if (event is Map) {
            return Map<String, dynamic>.from(event);
          }
          return {};
        })
        .cast<Map<String, dynamic>>()
        .handleError((error, stackTrace) {
          throw error;
        });
    return _eventStream!;
  }

  @override
  Future<void> initializeRoomCall({
    required String roomId,
    required String callId,
    required String whiteBoardId,
    required bool isChatEnable,
    required bool isRejoin,
  }) async {
    await methodChannel.invokeMethod(
      'initializeRoomCall',
      {
        'roomId': roomId,
        'callId': callId,
        'whiteBoardId': whiteBoardId,
        'isChatEnable': isChatEnable,
        'isRejoin': isRejoin,
      },
    );
  }

  @override
  Future<void> startTeamsMeetingCall({
    required String callId,
    required String meetingLink,
    required String whiteBoardId,
    required bool isChatEnable,
    required bool isRejoin,
  }) async {
    await methodChannel.invokeMethod(
      'startTeamsMeetingCall',
      {
        'callId': callId,
        'meetingLink': meetingLink,
        'whiteBoardId': whiteBoardId,
        'isChatEnable': isChatEnable,
        'isRejoin': isRejoin,
      },
    );
  }

  @override
  Future<void> startOneOnOneCall({
    required String callId,
    required String whiteBoardId,
    required List<String> participanstId,
    required String userId,
    required bool isRejoin,
  }) async {
    await methodChannel.invokeMethod(
      'startOneOnOneCall',
      {
        'callId': callId,
        'whiteBoardId': whiteBoardId,
        'participantId': participanstId,
        'userId': userId,
        'isRejoin': isRejoin,
      },
    );
  }

  @override
  Future<void> setUserData({
    required String token,
    required String name,
    required String userId,
  }) async {
    await methodChannel.invokeMethod(
      'setUserData',
      {
        'token': token,
        'name': name,
        'userId': userId,
      },
    );
  }

  @override
  Future<void> setBroadcastExtensionData({
    required String appGroupIdentifier,
    required String extensionBubdleId,
  }) async {
    await methodChannel.invokeMethod(
      'setBroadcastExtensionData',
      {
        'appGroupIdentifier': appGroupIdentifier,
        'extensionBubdleId': extensionBubdleId,
      },
    );
  }

  @override
  Future<void> returnToCall() async {
    await methodChannel.invokeMethod('returnToCall');
  }

  @override
  Future<void> setupChatService({
    required String endpoint,
  }) async {
    await methodChannel.invokeMethod(
      'setupChatService',
      {
        'endpoint': endpoint,
      },
    );
  }

  @override
  Future<void> initChatThread({
    required String threadId,
  }) async {
    await methodChannel.invokeMethod(
      'initChatThread',
      {
        'threadId': threadId,
      },
    );
  }

  @override
  Future<void> disconnectChatService() async {
    await methodChannel.invokeMethod('disconnectChatService');
  }

  @override
  Future<List<Map<String, dynamic>>> getInitialMessages({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'getInitialMessages',
      {
        'threadId': threadId,
      },
    );

    if (result == null) return [];

    // Cast each item in the result to Map<String, dynamic>
    final List<dynamic> rawList = result as List<dynamic>;
    return rawList.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<Map<String, dynamic>> retrieveChatThreadProperties({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'retrieveChatThreadProperties',
      {
        'threadId': threadId,
      },
    );
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<List<Map<String, dynamic>>> getListOfParticipants({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'getListOfParticipants',
      {
        'threadId': threadId,
      },
    );
    return (result as List)
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getPreviousMessages({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'getPreviousMessages',
      {
        'threadId': threadId,
      },
    );
    return (result as List)
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Future<String?> sendMessage({
    required String threadId,
    required String content,
    required String senderDisplayName,
    String? type,
    Map<String, String>? metadata,
  }) async {
    final result = await methodChannel.invokeMethod(
      'sendMessage',
      {
        'content': content,
        'senderDisplayName': senderDisplayName,
        'threadId': threadId,
        if (type != null) 'type': type,
        if (metadata != null) 'metadata': metadata,
      },
    );
    return result as String?;
  }

  @override
  Future<void> editMessage({
    required String threadId,
    required String messageId,
    required String content,
    Map<String, String>? metadata,
  }) async {
    await methodChannel.invokeMethod(
      'editMessage',
      {
        'messageId': messageId,
        'content': content,
        'threadId': threadId,
        if (metadata != null) 'metadata': metadata,
      },
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getListReadReceipts({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'getListReadReceipts',
      {
        'threadId': threadId,
      },
    );
    return (result as List)
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  @override
  Future<void> deleteMessage({
    required String threadId,
    required String messageId,
  }) async {
    await methodChannel.invokeMethod(
      'deleteMessage',
      {
        'messageId': messageId,
        'threadId': threadId,
      },
    );
  }

  @override
  Future<void> sendReadReceipt({
    required String threadId,
    required String messageId,
  }) async {
    await methodChannel.invokeMethod(
      'sendReadReceipt',
      {
        'messageId': messageId,
        'threadId': threadId,
      },
    );
  }

  @override
  Future<bool> isChatHasMoreMessages({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'isChatHasMoreMessages',
      {
        'threadId': threadId,
      },
    );

    return result as bool;
  }

  @override
  Future<List<Map<String, dynamic>>> getInitialListThreads() async {
    final result = await methodChannel.invokeMethod(
      'getInitialListThreads',
    );

    if (result == null) return [];

    // Cast each item in the result to Map<String, dynamic>
    final List<dynamic> rawList = result as List<dynamic>;
    return rawList.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getNextThreads() async {
    final result = await methodChannel.invokeMethod(
      'getNextThreads',
    );

    if (result == null) return [];

    // Cast each item in the result to Map<String, dynamic>
    final List<dynamic> rawList = result as List<dynamic>;
    return rawList.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<bool> isMoreThreadsAvailable() async {
    final result = await methodChannel.invokeMethod(
      'isMoreThreadsAvailable',
    );

    return result as bool;
  }

  @override
  Future<Map<String, dynamic>?> getPreloadedAction() async {
    final result = await methodChannel.invokeMethod(
      'getPreloadedAction',
    );

    if (result == null) {
      return null;
    }

    return Map<String, dynamic>.from(result);
  }

  @override
  Future<Map<String, dynamic>?> getLastMessage({
    required String threadId,
  }) async {
    final result = await methodChannel.invokeMethod(
      'getLastMessage',
      {
        'threadId': threadId,
      },
    );

    if (result == null) {
      return null;
    }

    return Map<String, dynamic>.from(result);
  }

  @override
  Future<void> sendTypingIndicator({
    required String threadId,
  }) async {
    await methodChannel.invokeMethod(
      'sendTypingIndicator',
      {
        'threadId': threadId,
      },
    );
  }

  Future<dynamic> _handleNativeMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getToken':
        final token = await onTokenRefreshRequested!();
        return token;
    }
  }
}
