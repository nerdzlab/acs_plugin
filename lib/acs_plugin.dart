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

  Future<void> toggleLocalVideo() async {
    await AcsPluginPlatform.instance.toggleLocalVideo();
  }

  Future<void> toggleParticipantVideo(String participantId) async {
    await AcsPluginPlatform.instance.toggleParticipantVideo(participantId);
  }

  Future<void> switchCamera() async {
    await AcsPluginPlatform.instance.switchCamera();
  }

// Stream to listen for events
  Stream<Map<String, dynamic>> get eventStream {
    return AcsPluginPlatform.instance.eventStream;
  }
}
