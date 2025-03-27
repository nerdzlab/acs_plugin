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
  Future<void> startCall() async {
    try {
      await methodChannel.invokeMethod('startCall');
    } on PlatformException catch (e) {
      print("Error starting call: ${e.message}");
      rethrow;
    }
  }

  @override
  Future<void> endCall() async {
    try {
      await methodChannel.invokeMethod('endCall');
    } on PlatformException catch (e) {
      print("Error ending call: ${e.message}");
      rethrow;
    }
  }
}
