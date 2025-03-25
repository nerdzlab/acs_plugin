
import 'acs_plugin_platform_interface.dart';

class AcsPlugin {
  Future<String?> getPlatformVersion() {
    return AcsPluginPlatform.instance.getPlatformVersion();
  }
}
