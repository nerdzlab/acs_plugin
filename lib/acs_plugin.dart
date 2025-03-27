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
  Future<void> startCall() async {
    await AcsPluginPlatform.instance.startCall();
  }

  // End a call
  Future<void> endCall() async {
    await AcsPluginPlatform.instance.endCall();
  }
}
