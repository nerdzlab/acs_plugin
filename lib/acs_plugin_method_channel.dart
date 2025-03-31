import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'acs_plugin_platform_interface.dart';

/// An implementation of [AcsPluginPlatform] that uses method channels.
class MethodChannelAcsPlugin extends AcsPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('acs_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> requestMicrophonePermissions() async {
    try {
      final bool result =
          await methodChannel.invokeMethod('requestMicrophonePermissions');
      return result;
    } on PlatformException catch (e) {
      log("Error toggling local video: ${e.message}");
      return false;
    }
  }

  @override
  Future<bool> requestCameraPermissions() async {
    try {
      final bool result =
          await methodChannel.invokeMethod('requestCameraPermissions');
      return result;
    } on PlatformException catch (e) {
      log("Error toggling local video: ${e.message}");
      return false;
    }
  }

  @override
  Future<void> initializeCall(String token) async {
    try {
      final String result = await methodChannel.invokeMethod(
        'initializeCall',
        {'token': token},
      );

      log(result);
    } on PlatformException catch (e) {
      log("Error initializing ACS: ${e.message}");
      rethrow;
    }
  }

  @override
  Future<void> joinRoom(String roomId) async {
    try {
      final String result = await methodChannel.invokeMethod(
        'joinRoom',
        {'roomId': roomId},
      );
      log(result);
    } on PlatformException catch (e) {
      log("Error starting call: ${e.message}");
      rethrow;
    }
  }

  @override
  Future<void> leaveRoomCall() async {
    try {
      final String result = await methodChannel.invokeMethod('leaveRoomCall');
      log(result);
    } on PlatformException catch (e) {
      log("Error ending call: ${e.message}");
      rethrow;
    }
  }

  @override
  Future<bool> toggleMute() async {
    try {
      final bool muted = await methodChannel.invokeMethod('toggleMute');
      return muted;
    } on PlatformException catch (e) {
      log("Failed to toggle mute: ${e.message}");
      return false;
    }
  }

  @override
  Future<bool> toggleSpeaker() async {
    try {
      final bool speakerEnabled =
          await methodChannel.invokeMethod('toggleSpeaker');
      return speakerEnabled;
    } on PlatformException catch (e) {
      log("Failed to toggle speaker: ${e.message}");
      return false;
    }
  }

  @override
  Future<String?> toggleLocalVideo() async {
    try {
      final String? viewId =
          await methodChannel.invokeMethod('toggleLocalVideo');
      return viewId; // This viewId will be used in the Flutter UI
    } on PlatformException catch (e) {
      log("Error toggling local video: ${e.message}");
      return null;
    }
  }
}
