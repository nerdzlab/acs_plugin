import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'acs_plugin_method_channel.dart';

abstract class AcsPluginPlatform extends PlatformInterface {
  /// Constructs a AcsPluginPlatform.
  AcsPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AcsPluginPlatform _instance = MethodChannelAcsPlugin();

  /// The default instance of [AcsPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelAcsPlugin].
  static AcsPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AcsPluginPlatform] when
  /// they register themselves.
  static set instance(AcsPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> requestMicrophonePermissions() {
    throw UnimplementedError(
        'requestMicrophonePermissions() has not been implemented.');
  }

  Future<bool> requestCameraPermissions() {
    throw UnimplementedError(
        'requestCameraPermissions() has not been implemented.');
  }

  Future<void> initializeRoomCall({
    required String token,
    required String roomId,
    required String userId,
    required bool isChatEnable,
    required bool isRejoin,
  }) {
    throw UnimplementedError('initializeRoomCall() has not been implemented.');
  }

  Future<void> startOneOnOneCall({
    required String token,
    required String participantId,
    required String userId,
  }) {
    throw UnimplementedError('startOneOnOneCall() has not been implemented.');
  }

  Future<void> setUserData({
    required String token,
    required String name,
    required String userId,
  }) {
    throw UnimplementedError('setUserData() has not been implemented.');
  }

  Future<void> setBroadcastExtensionData({
    required String appGroupIdentifier,
    required String extensionBubdleId,
  }) {
    throw UnimplementedError(
        'setBroadcastExtensionData() has not been implemented.');
  }

  Future<void> returnToCall() async {
    throw UnimplementedError('returnToCall() has not been implemented.');
  }

  Future<void> setupChat({
    required String endpoint,
    required String threadId,
  }) async {
    throw UnimplementedError('setupChat() has not been implemented.');
  }

  Future<void> disconnectChat() async {
    throw UnimplementedError('disconnectChat() has not been implemented.');
  }

  Stream<Map<String, dynamic>> get eventStream {
    throw UnimplementedError('eventStream has not been implemented.');
  }
}
