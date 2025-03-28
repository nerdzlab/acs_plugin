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

  // Add your ACS methods here, like initialize, startCall, endCall
  Future<void> initializeCall(String token) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> joinRoom(String roomId) {
    throw UnimplementedError('joinRoom() has not been implemented.');
  }

  Future<void> leaveRoomCall() {
    throw UnimplementedError('leaveRoomCall() has not been implemented.');
  }

  Future<bool> toggleMute() {
    throw UnimplementedError('toggleMute() has not been implemented.');
  }

  Future<bool> toggleSpeaker() {
    throw UnimplementedError('toggleSpeaker() has not been implemented.');
  }
}
