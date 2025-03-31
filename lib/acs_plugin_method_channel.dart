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
  Future<void> joinRoom(String roomId) async {
    await methodChannel.invokeMethod(
      'joinRoom',
      {'roomId': roomId},
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
