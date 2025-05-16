import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'acs_plugin_platform_interface.dart';

/// An implementation of [AcsPluginPlatform] that uses method channels.
class MethodChannelAcsPlugin extends AcsPluginPlatform {
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
    required String token,
    required String roomId,
    required String userId,
    required bool isChatEnable,
    required bool isRejoin,
  }) async {
    await methodChannel.invokeMethod(
      'initializeRoomCall',
      {
        'token': token,
        'roomId': roomId,
        'userId': userId,
        'isChatEnable': isChatEnable,
        'isRejoin': isRejoin,
      },
    );
  }

  @override
  Future<void> startOneOnOneCall({
    required String token,
    required String participantId,
    required String userId,
  }) async {
    await methodChannel.invokeMethod(
      'startOneOnOneCall',
      {
        'token': token,
        'participantId': participantId,
        'userId': userId,
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
  Future<void> setupChat({
    required String endpoint,
    required String threadId,
  }) async {
    await methodChannel.invokeMethod(
      'setupChat',
      {
        'endpoint': endpoint,
        'threadId': threadId,
      },
    );
  }

  @override
  Future<void> disconnectChat() async {
    await methodChannel.invokeMethod('disconnectChat');
  }

  @override
  Future<List<Map<String, dynamic>>> getInitialMessages() async {
    final result = await methodChannel.invokeMethod('getInitialMessages');

    if (result == null) return [];

    // Cast each item in the result to Map<String, dynamic>
    final List<dynamic> rawList = result as List<dynamic>;
    return rawList.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  @override
  Future<Map<String, dynamic>> retrieveChatThreadProperties() async {
    final result =
        await methodChannel.invokeMethod('retrieveChatThreadProperties');
    return Map<String, dynamic>.from(result);
  }

  @override
  Future<List<Map<String, dynamic>>> getListOfParticipants() async {
    final result = await methodChannel.invokeMethod('getListOfParticipants');
    return (result as List)
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getPreviousMessages() async {
    final result = await methodChannel.invokeMethod('getPreviousMessages');
    return (result as List)
        .cast<Map>()
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();
  }

  @override
  Future<String?> sendMessage({
    required String content,
    required String senderDisplayName,
  }) async {
    final result = await methodChannel.invokeMethod(
      'sendMessage',
      {
        'content': content,
        'senderDisplayName': senderDisplayName,
      },
    );
    return result as String?;
  }

  @override
  Future<void> editMessage({
    required String messageId,
    required String content,
  }) async {
    await methodChannel.invokeMethod(
      'editMessage',
      {
        'messageId': messageId,
        'content': content,
      },
    );
  }

  @override
  Future<void> deleteMessage({
    required String messageId,
  }) async {
    await methodChannel.invokeMethod(
      'deleteMessage',
      {
        'messageId': messageId,
      },
    );
  }

  @override
  Future<void> sendReadReceipt({
    required String messageId,
  }) async {
    await methodChannel.invokeMethod(
      'sendReadReceipt',
      {
        'messageId': messageId,
      },
    );
  }

  @override
  Future<void> sendTypingIndicator() async {
    await methodChannel.invokeMethod('sendTypingIndicator');
  }
}
