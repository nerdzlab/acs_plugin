import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'acs_plugin_platform_interface.dart';

/// An implementation of [AcsPluginPlatform] that uses method channels.
class MethodChannelAcsPlugin extends AcsPluginPlatform {
  /// The method channel used to interact with the native platform.
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
            // Convert the event to Map<String, dynamic>
            return Map<String, dynamic>.from(event);
          }
          return {}; // Return an empty map if it's not of type Map
        })
        .cast<
            Map<String,
                dynamic>>() // Cast the stream to Stream<Map<String, dynamic>>
        .handleError((error, stackTrace) {
          throw error;
        });
    return _eventStream!;
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> requestMicrophonePermissions() async {
    return await methodChannel.invokeMethod('requestMicrophonePermissions');
  }

  @override
  Future<bool> requestCameraPermissions() async {
    return await methodChannel.invokeMethod('requestCameraPermissions');
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
    await methodChannel.invokeMethod(
      'returnToCall',
    );
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
}
