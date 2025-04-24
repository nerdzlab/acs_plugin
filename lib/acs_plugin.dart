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
  }) async {
    await AcsPluginPlatform.instance.initializeRoomCall(
      token: token,
      roomId: roomId,
    );
  }

// Stream to listen for events
  Stream<Map<String, dynamic>> get eventStream {
    return AcsPluginPlatform.instance.eventStream;
  }
}
