import 'acs_plugin_platform_interface.dart';

class AcsPlugin {
  Future<String?> getPlatformVersion() {
    return AcsPluginPlatform.instance.getPlatformVersion();
  }

  // Initialize the ACS plugin with a token
  Future<void> initializeCall({required String token}) async {
    await AcsPluginPlatform.instance.initializeCall(token);
  }

  // Start a call
  Future<void> joinRoom({required String roomId}) async {
    await AcsPluginPlatform.instance.joinRoom(roomId);
  }

  // End a call
  Future<void> leaveRoomCall() async {
    await AcsPluginPlatform.instance.leaveRoomCall();
  }

  Future<bool> toggleMute() async {
    return await AcsPluginPlatform.instance.toggleMute();
  }

  Future<bool> toggleSpeaker() async {
    return await AcsPluginPlatform.instance.toggleSpeaker();
  }

  Future<String?> toggleLocalVideo() async {
    return await AcsPluginPlatform.instance.toggleLocalVideo();
  }
}
