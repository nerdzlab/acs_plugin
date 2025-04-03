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
  Future<void> initializeCall(String token) async {
    await methodChannel.invokeMethod(
      'initializeCall',
      {'token': token},
    );
  }

  @override
  Future<String?> joinRoom(String roomId) async {
    return await methodChannel.invokeMethod(
      'joinRoom',
      {'room_id': roomId},
    );
  }

  @override
  Future<String?> toggleParticipantVideo(String participantId) async {
    return await methodChannel.invokeMethod(
      'toggleParticipantVideo',
      {'participant_id': participantId},
    );
  }

  @override
  Future<void> leaveRoomCall() async {
    await methodChannel.invokeMethod('leaveRoomCall');
  }

  @override
  Future<bool> toggleMute() async {
    return await methodChannel.invokeMethod('toggleMute');
  }

  @override
  Future<bool> toggleSpeaker() async {
    return await methodChannel.invokeMethod('toggleSpeaker');
  }

  @override
  Future<String?> toggleLocalVideo() async {
    return await methodChannel.invokeMethod('toggleLocalVideo');
  }
}
