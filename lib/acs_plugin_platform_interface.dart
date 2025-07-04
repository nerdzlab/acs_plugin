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

  Future<String> Function()? onTokenRefreshRequested;

  Future<void> initializeRoomCall({
    required String roomId,
    required String callId,
    required String whiteBoardId,
    required bool isChatEnable,
    required bool isRejoin,
  }) {
    throw UnimplementedError('initializeRoomCall() has not been implemented.');
  }

  Future<void> startOneOnOneCall({
    required List<String> participanstId,
  }) {
    throw UnimplementedError('startOneOnOneCall() has not been implemented.');
  }

  Future<void> startTeamsMeetingCall({
    required String meetingLink,
    required String callId,
    required String whiteBoardId,
    required bool isChatEnable,
    required bool isRejoin,
  }) {
    throw UnimplementedError(
        'startTeamsMeetingCall() has not been implemented.');
  }

  Future<void> setUserData({
    required String token,
    required String name,
    required String userId,
    required String languageCode,
    required String appToken,
    required String baseUrl,
  }) {
    throw UnimplementedError('setUserData() has not been implemented.');
  }

  Future<void> clearUserData() {
    throw UnimplementedError('clearUserData() has not been implemented.');
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

  Future<void> setupChatService({
    required String endpoint,
  }) async {
    throw UnimplementedError('setupChatService() has not been implemented.');
  }

  Future<void> initChatThread({
    required String threadId,
  }) async {
    throw UnimplementedError('initChatThread() has not been implemented.');
  }

  Future<void> disconnectChatService() async {
    throw UnimplementedError(
        'disconnectChatService() has not been implemented.');
  }

  Future<void> unregisterPushNotifications() async {
    throw UnimplementedError(
        'unregisterPushNotifications() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getInitialMessages({
    required String threadId,
  }) async {
    throw UnimplementedError('getInitialMessages() has not been implemented.');
  }

  Future<Map<String, dynamic>> retrieveChatThreadProperties({
    required String threadId,
  }) async {
    throw UnimplementedError(
        'retrieveChatThreadProperties() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getListOfParticipants({
    required String threadId,
  }) async {
    throw UnimplementedError(
        'getListOfParticipants() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getListReadReceipts({
    required String threadId,
  }) async {
    throw UnimplementedError('getListReadReceipts() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getPreviousMessages({
    required String threadId,
  }) async {
    throw UnimplementedError('getPreviousMessages() has not been implemented.');
  }

  Future<String?> sendMessage({
    required String threadId,
    required String content,
    required String senderDisplayName,
    String? type,
    Map<String, String>? metadata,
  }) async {
    throw UnimplementedError('sendMessage() has not been implemented.');
  }

  Future<void> editMessage({
    required String threadId,
    required String messageId,
    required String content,
    Map<String, String>? metadata,
  }) async {
    throw UnimplementedError('editMessage() has not been implemented.');
  }

  Future<void> deleteMessage({
    required String threadId,
    required String messageId,
  }) async {
    throw UnimplementedError('deleteMessage() has not been implemented.');
  }

  Future<void> sendReadReceipt({
    required String threadId,
    required String messageId,
  }) async {
    throw UnimplementedError('sendReadReceipt() has not been implemented.');
  }

  Future<void> sendTypingIndicator({
    required String threadId,
  }) async {
    throw UnimplementedError('sendTypingIndicator() has not been implemented.');
  }

  Future<bool> isChatHasMoreMessages({
    required String threadId,
  }) async {
    throw UnimplementedError(
        'isChatHasMoreMessages() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getPreloadedAction() async {
    throw UnimplementedError('getPreloadedAction() has not been implemented.');
  }

  Future<Map<String, dynamic>?> getLastMessage({
    required String threadId,
  }) async {
    throw UnimplementedError('getLastMessage() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getInitialListThreads() async {
    throw UnimplementedError(
        'getInitialListThreads() has not been implemented.');
  }

  Future<List<Map<String, dynamic>>> getNextThreads() async {
    throw UnimplementedError('getNextThreads() has not been implemented.');
  }

  Future<bool> isMoreThreadsAvailable() async {
    throw UnimplementedError(
        'isMoreThreadsAvailable() has not been implemented.');
  }

  // Event stream for chat events etc.
  Stream<Map<String, dynamic>> get eventStream {
    throw UnimplementedError('eventStream has not been implemented.');
  }
}
