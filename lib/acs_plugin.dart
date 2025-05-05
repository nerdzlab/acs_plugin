import 'acs_plugin_platform_interface.dart';

class AcsPlugin {
  Future<String?> getPlatformVersion() {
    return AcsPluginPlatform.instance.getPlatformVersion();
  }

  Future<bool> requestMicrophonePermissions() async {
    return await AcsPluginPlatform.instance.requestMicrophonePermissions();
  }

  Future<bool> requestCameraPermissions() async {
    return await AcsPluginPlatform.instance.requestCameraPermissions();
  }

  // Initialize the room call
  Future<void> initializeRoomCall({
    required String token,
    required String roomId,
    required String userId,
    required bool isChatEnable,
  }) async {
    await AcsPluginPlatform.instance.initializeRoomCall(
      token: token,
      roomId: roomId,
      userId: userId,
      isChatEnable: isChatEnable,
    );
  }

  // Start one on one call
  Future<void> startOneOnOneCall({
    required String token,
    required String participantId,
    required String userId,
  }) async {
    await AcsPluginPlatform.instance.startOneOnOneCall(
      token: token,
      participantId: participantId,
      userId: userId,
    );
  }

  // Set user data
  Future<void> setUserData({
    required String token,
    required String name,
    required String userId,
  }) async {
    await AcsPluginPlatform.instance.setUserData(
      token: token,
      name: name,
      userId: userId,
    );
  }

  // Need to show call ui
  Future<void> returnToCall() async {
    await AcsPluginPlatform.instance.returnToCall();
  }

// Stream to listen for events
  Stream<Map<String, dynamic>> get eventStream {
    return AcsPluginPlatform.instance.eventStream;
  }
}
