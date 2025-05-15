import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'acs_plugin_method_channel.dart';

abstract class AcsPluginPlatform extends PlatformInterface {
  AcsPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static AcsPluginPlatform _instance = MethodChannelAcsPlugin();

  static AcsPluginPlatform get instance => _instance;

  static set instance(AcsPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
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

  Future<List<Map<String, dynamic>>> getInitialMessages() async {
    throw UnimplementedError('getInitialMessages() has not been implemented.');
  }

  Future<Map<String, dynamic>> retrieveChatThreadProperties() async {
    throw UnimplementedError(
        'retrieveChatThreadProperties() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getListOfParticipants() async {
    throw UnimplementedError(
        'getListOfParticipants() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getPreviousMessages() async {
    throw UnimplementedError('getPreviousMessages() has not been implemented.');
  }

  Future<String?> sendMessage({
    required String content,
    required String senderDisplayName,
  }) async {
    throw UnimplementedError('sendMessage() has not been implemented.');
  }

  Future<void> editMessage({
    required String messageId,
    required String content,
  }) async {
    throw UnimplementedError('editMessage() has not been implemented.');
  }

  Future<void> deleteMessage({
    required String messageId,
  }) async {
    throw UnimplementedError('deleteMessage() has not been implemented.');
  }

  Future<void> sendReadReceipt({
    required String messageId,
  }) async {
    throw UnimplementedError('sendReadReceipt() has not been implemented.');
  }

  Future<void> sendTypingIndicator() async {
    throw UnimplementedError('sendTypingIndicator() has not been implemented.');
  }

  // Event stream for chat events etc.
  Stream<Map<String, dynamic>> get eventStream {
    throw UnimplementedError('eventStream has not been implemented.');
  }
}
