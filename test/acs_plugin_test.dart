import 'package:flutter_test/flutter_test.dart';
import 'package:acs_plugin/acs_plugin.dart';
import 'package:acs_plugin/acs_plugin_platform_interface.dart';
import 'package:acs_plugin/acs_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAcsPluginPlatform
    with MockPlatformInterfaceMixin
    implements AcsPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AcsPluginPlatform initialPlatform = AcsPluginPlatform.instance;

  test('$MethodChannelAcsPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAcsPlugin>());
  });

  test('getPlatformVersion', () async {
    AcsPlugin acsPlugin = AcsPlugin();
    MockAcsPluginPlatform fakePlatform = MockAcsPluginPlatform();
    AcsPluginPlatform.instance = fakePlatform;

    expect(await acsPlugin.getPlatformVersion(), '42');
  });
}
