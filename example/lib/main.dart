import 'dart:developer';

import 'package:acs_plugin/acs_plugin_error.dart';
import 'package:acs_plugin/chat_models/chat_message_edited_event/chat_message_edited_event.dart';
import 'package:acs_plugin/chat_models/chat_message_received_event/chat_message_received_event.dart';
import 'package:acs_plugin/chat_models/chat_messge_deleted_event/chat_messge_deleted_event.dart';
import 'package:acs_plugin/chat_models/chat_thread_created_event/chat_thread_created_event.dart';
import 'package:acs_plugin/chat_models/chat_thread_deleted_event/chat_thread_deleted_event.dart';
import 'package:acs_plugin/chat_models/chat_thread_properties_updated_event/chat_thread_properties_updated_event.dart';
import 'package:acs_plugin/chat_models/participants_added_event/participants_added_event.dart';
import 'package:acs_plugin/chat_models/participants_removed_event/participants_removed_event.dart';
import 'package:acs_plugin/chat_models/push_notification_chat_message_received_event/push_notification_chat_message_received_event.dart';
import 'package:acs_plugin/chat_models/read_receipt_received_event/read_receipt_received_event.dart';
import 'package:acs_plugin/chat_models/typing_indicator_received_event/typing_indicator_received_event.dart';
import 'package:acs_plugin_example/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:acs_plugin/acs_plugin.dart';
import 'package:safe_device/safe_device.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACS Plugin Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CallScreen(),
    );
  }
}

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _acsPlugin = AcsPlugin();
  bool isRealDevice = false;

  // Configuration constants - move to a config file in a real app
  String get _acsToken {
    if (_isSuperBrainsMode) {
      return Constants.superBrainsUserToken;
    } else if (isRealDevice) {
      return Constants.userOneToken;
    } else {
      return Constants.userTwoToken;
    }
  }

  bool get _isSuperBrainsMode {
    return true;
  }

  String get _whiteBoardId {
    return Constants.whiteBoardId;
  }

  String get _callId {
    return Constants.callId;
  }

  static const String _roomId = Constants.roomId;
  static const _appGroupIdentifier = Constants.appGroupIdentifier;
  static const _extensionBundleId = Constants.extensionBundleId;

  static const String _endpoint = Constants.endpoint;
  static const String _threadId = Constants.threadId;
  static const String _teemsMeetingLink = Constants.teemsMeetingLink;

  String get _userId {
    if (_isSuperBrainsMode) {
      return Constants.superBrainsUserId;
    } else if (isRealDevice) {
      return Constants.userOneId;
    } else {
      return Constants.userTwoId;
    }
  }

  String get _otherUserId {
    // if (_isSuperBrainsMode) {
    //   return "8:acs:6d1413cf-2d24-4191-a570-11da916e8425_00000027-b650-e160-28d2-493a0d005b28";
    // }

    if (isRealDevice) {
      return Constants.userTwoId;
    } else {
      return Constants.userOneId;
    }
  }

  String get _userName {
    if (isRealDevice) {
      return Constants.userOneName;
    } else {
      return Constants.userTwoName;
    }
  }

  @override
  initState() {
    super.initState();
    _setBroadcastExtensionData();
    _subscribeToEvents();

    _acsPlugin.init();
    _setDeviceType();
  }

  Future<String> _onTokenRefreshRequested() async {
    // Simulate a delay like a network request
    await Future.delayed(const Duration(milliseconds: 500));

    // Return a fake token
    final token = "_generateMockToken";
    log('Mock token provided to native side: $token');
    return token;
  }

  _setDeviceType() async {
    isRealDevice = await SafeDevice.isRealDevice;
    _setUserData();
  }

  _subscribeToEvents() {
    _acsPlugin
      ..onCallUIClosed = () {
        log("Call UI closed");
        _shwoSnacBar("Call ui closed");
      }
      ..onStopScreenShare = () {
        log("Screen sharing stopped");
      }
      ..onStartScreenShare = () {
        log("Screen sharing started");
      }
      ..onShowChat = (azureCorrelationId) {
        log("Show chat triggered for azureCorrelationId ${azureCorrelationId}");
        _shwoSnacBar(
            "Show chat triggered for azureCorrelationId ${azureCorrelationId}");
      }
      ..onPluginStarted = () {
        log("Plugin started");
        _shwoSnacBar("Plugin started");
      }
      ..onUserCallEnded = () {
        log("User call ended");
        _shwoSnacBar("User ended call");
      }
      ..onOneOnOneCallEnded = () {
        log("User one on one call ended");
        _shwoSnacBar("User one on one call ended");
      }
      ..onRealTimeNotificationConnected = () {
        log("Real-time notification connected");
      }
      ..onRealTimeNotificationDisconnected = () {
        log("Real-time notification disconnected");
      }
      ..onChatMessageReceived = (ChatMessageReceivedEvent event) {
        log("Chat message received: ${event.toString()}");
      }
      ..onTypingIndicatorReceived = (TypingIndicatorReceivedEvent event) {
        log("Typing indicator received: ${event.toString()}");
      }
      ..onReadReceiptReceived = (ReadReceiptReceivedEvent event) {
        log("Read receipt received: ${event.toString()}");
      }
      ..onChatMessageEdited = (ChatMessageEditedEvent event) {
        log("Chat message edited: ${event.toString()}");
      }
      ..onChatMessageDeleted = (ChatMessageDeletedEvent event) {
        log("Chat message deleted: ${event.toString()}");
      }
      ..onChatThreadCreated = (ChatThreadCreatedEvent event) {
        log("Chat thread created: ${event.toString()}");
      }
      ..onChatThreadPropertiesUpdated =
          (ChatThreadPropertiesUpdatedEvent event) {
        log("Chat thread properties updated: ${event.toString()}");
      }
      ..onChatThreadDeleted = (ChatThreadDeletedEvent event) {
        log("Chat thread deleted: ${event.toString()}");
      }
      ..onParticipantsAdded = (ParticipantsAddedEvent event) {
        log("Participants added: ${event.toString()}");
      }
      ..onParticipantsRemoved = (ParticipantsRemovedEvent event) {
        log("Participants removed: ${event.toString()}");
      }
      ..onError = (ACSPluginError error) {
        log("Received error: ${error.toString()}");
      }
      ..onTokenRefreshRequested = () async {
        return _onTokenRefreshRequested();
      }
      ..onChatPushNotificationOpened =
          (PushNotificationChatMessageReceivedEvent event) {
        log("Chat push opened: ${event.toString()}");
      };
  }

  @override
  dispose() {
    _acsPlugin.dispose();
    super.dispose();
  }

  _shwoSnacBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(text),
      ),
    );
  }

  // Call management methods
  Future<void> initializeRoomCall() async {
    try {
      await _acsPlugin.initializeRoomCall(
        roomId: _roomId,
        callId: _callId,
        whiteBoardId: _whiteBoardId,
        isChatEnable: true,
        isRejoin: false,
      );
      log('Room call initialized successfully');
      _shwoSnacBar('Room call initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize room call: ${error.message}');
      _shwoSnacBar('Failed to initialize room call: ${error.message}');
    }
  }

  // Call management methods
  Future<void> _startTeamsMeetingCall() async {
    try {
      await _acsPlugin.startTeamsMeetingCall(
        callId: _callId,
        meetingLink: _teemsMeetingLink,
        whiteBoardId: _whiteBoardId,
        isChatEnable: true,
        isRejoin: false,
      );
      log('Meeting call initialized successfully');
      _shwoSnacBar('Meeting call initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize meeting call: ${error.message}');
      _shwoSnacBar('Failed to initialize meeting call: ${error.message}');
    }
  }

  // One on one call methods
  Future<void> _startOneOnOneCall() async {
    try {
      await _acsPlugin.startOneOnOneCall(
        participantsId: [_otherUserId],
      );
      log('One on one call initialized successfully');
      _shwoSnacBar('One on one call initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize one on one call: ${error.message}');
      _shwoSnacBar('Failed to initialize one on one call: ${error.message}');
    }
  }

  // Set user data
  Future<void> _setUserData() async {
    try {
      await _acsPlugin.setUserData(
          token: _acsToken,
          name: _userName,
          userId: _userId,
          languageCode: 'nl',
          appToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjA1YTI0NzdhLWRmODUtNGRiNy1iNzQ5LWYyMjQwNzAxOGIzZCIsIm9yZ2FuaXphdGlvbl9pZCI6IjY1NzU2ZTgzLTAwYjUtNDc1NS04M2EzLTAwZGQyYzFhYTY5MSIsImlzX29uYm9hcmRlZCI6dHJ1ZSwic3luY19wYXRpZW50X2RhdGEiOmZhbHNlLCJ2aWRlb19jYWxsX3Byb3ZpZGVyIjoiaG1zIiwiaHR0cHM6Ly9oYXN1cmEuaW8vand0L2NsYWltcyI6eyJ4LWhhc3VyYS1hbGxvd2VkLXJvbGVzIjpbInVzZXIiXSwieC1oYXN1cmEtZGVmYXVsdC1yb2xlIjoidXNlciIsIngtaGFzdXJhLXVzZXItaWQiOiIwNWEyNDc3YS1kZjg1LTRkYjctYjc0OS1mMjI0MDcwMThiM2QifSwicm9sZSI6InVzZXIiLCJhY2NvdW50X3R5cGUiOm51bGwsImlhdCI6MTc0OTEzMjExOSwiZXhwIjoxNzUxNzI0MTE5LCJzdWIiOiIwNWEyNDc3YS1kZjg1LTRkYjctYjc0OS1mMjI0MDcwMThiM2QifQ.75JB4Jr0Oebx5eF7nlJQxBu9Oe_BytEZ-LrF9vYKkDo",
          baseUrl: "https://api-msteam.superbrains.nl/v1/graphql"
      );
      log('Set user data successfully');
      _shwoSnacBar('Set user data successfully');
    } on PlatformException catch (error) {
      log('Failed to set user data: ${error.message}');
      _shwoSnacBar('Failed to set user data: ${error.message}');
    }
  }

  // Set broadcast extension data
  // Only for iOS
  Future<void> _setBroadcastExtensionData() async {
    try {
      await _acsPlugin.setBroadcastExtensionData(
        appGroupIdentifier: _appGroupIdentifier,
        extensionBubdleId: _extensionBundleId,
      );
      log('Set broadcast extension data successfully');
      _shwoSnacBar('Set broadcast data successfully');
    } on PlatformException catch (error) {
      log('Failed to set broadcast data: ${error.message}');
      _shwoSnacBar('Failed to set broadcast data: ${error.message}');
    }
  }

  Future<void> _setupChatService() async {
    try {
      await _acsPlugin.setupChatService(
        endpoint: _endpoint,
      );
      _initChatThread();
      log('Chat initialized successfully');
      _shwoSnacBar('Chat initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize chat: ${error.message}');
      _shwoSnacBar('Failed to initialize chat: ${error.message}');
    }
  }

  Future<void> _initChatThread() async {
    try {
      await _acsPlugin.initChatThread(
        threadId: _threadId,
      );
      log('Chat thread initialized successfully');
      _shwoSnacBar('Chat thread initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize chat thread: ${error.message}');
      _shwoSnacBar('Failed to initialize chat thread: ${error.message}');
    }
  }

  Future<void> _getChatMessages() async {
    try {
      final messages = await _acsPlugin.getInitialMessages(threadId: _threadId);
      log('Chat initialized successfully');
      _shwoSnacBar('Chat messages successfully fetched');
    } on PlatformException catch (error) {
      log('Failed to get chat messages: ${error.toString()}');
      _shwoSnacBar('Failed to get chat messages: ${error.message}');
    }
  }

  Future<void> _getLastMessage() async {
    try {
      final message = await _acsPlugin.getLastMessage(threadId: _threadId);
      log('Last message successfully fetched');
      _shwoSnacBar('Last message successfully fetched');
    } on PlatformException catch (error) {
      log('Failed to get last chat messages: ${error.toString()}');
      _shwoSnacBar('Failed to get last chat messages: ${error.message}');
    }
  }

  Future<void> _disconnectChatService() async {
    try {
      await _acsPlugin.disconnectChatService();
      log('Chat disconnected successfully');
      _shwoSnacBar('Chat disconnected successfully');
    } on PlatformException catch (error) {
      log('Failed to disconnected chat: ${error.message}');
      _shwoSnacBar('Failed to disconnected chat: ${error.message}');
    }
  }

  Future<void> _unregisterPushNotifications() async {
    _acsPlugin.unregisterPushNotifications();
  }

  // Get info if chat has more messages
  Future<void> _isChatHasMoreMessages() async {
    try {
      final isChatHasMoreMessages =
      await _acsPlugin.isChatHasMoreMessages(threadId: _threadId);
      log('Chat has more messages: $isChatHasMoreMessages');
      _shwoSnacBar('Chat has more messages: $isChatHasMoreMessages');
    } on PlatformException catch (error) {
      log('Failed to fetch isChatHasMoreMessages: ${error.message}');
      _shwoSnacBar('Failed to fetch isChatHasMoreMessages: ${error.message}');
    }
  }

  Future<void> _sendTestMessage() async {
    try {
      final messageId = await _acsPlugin.sendMessage(
          threadId: _threadId,
          content: "Test message from plugin",
          senderDisplayName: "ACS Plugin");
      log('Chat message sent, result: $messageId');
      _shwoSnacBar('Chat message sent, result: $messageId');
    } on PlatformException catch (error) {
      log('Failed to send chat message: ${error.message}');
      _shwoSnacBar('Failed to send chat message: ${error.message}');
    }
  }

  Future<void> _getListReadReceipts() async {
    try {
      final listReadReceipts = await _acsPlugin.getListReadReceipts(
        threadId: _threadId,
      );
      log('Get read list receipts: ${listReadReceipts.length}');
      _shwoSnacBar('Get read list receipts: ${listReadReceipts.length}');
    } on PlatformException catch (error) {
      log('Failed to get list read message: ${error.message}');
      _shwoSnacBar('Failed to get list read message: ${error.message}');
    }
  }

  Future<void> _getInitialListThreads() async {
    try {
      final threads = await _acsPlugin.getInitialListThreads();
      log('Threads successfully fetched');
      _shwoSnacBar('Threads successfully fetched: ${threads.length}');
    } on PlatformException catch (error) {
      log('Failed to get threads: ${error.toString()}');
      _shwoSnacBar('Failed to get threads: ${error.message}');
    }
  }

  Future<void> _isMoreThreadsAvailable() async {
    try {
      final isMoreThreadsAvailable = await _acsPlugin.isMoreThreadsAvailable();
      log('More threads available: ${isMoreThreadsAvailable}');
      _shwoSnacBar('More threads available: ${isMoreThreadsAvailable}');
    } on PlatformException catch (error) {
      log('Failed to get info about more threads: ${error.toString()}');
      _shwoSnacBar('Failed to get info about more threads: ${error.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACS Plugin Demo'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Setup Section
              _buildSectionHeader('Setup'),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'Init room call',
                  onTap: initializeRoomCall,
                  icon: Icons.cloud,
                ),
                ButtonConfig(
                  label: 'One on One call',
                  onTap: _startOneOnOneCall,
                  icon: Icons.mic,
                ),
                ButtonConfig(
                  label: 'Teems meeting call',
                  onTap: _startTeamsMeetingCall,
                  icon: Icons.mic,
                ),
              ]),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'Setup chat service',
                  onTap: _setupChatService,
                  icon: Icons.message,
                ),
                ButtonConfig(
                  label: 'Disconnect chat service',
                  onTap: _disconnectChatService,
                  icon: Icons.message,
                ),
                ButtonConfig(
                  label: 'Get chat messages',
                  onTap: _getChatMessages,
                  icon: Icons.message,
                ),
              ]),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'Check more messages',
                  onTap: _isChatHasMoreMessages,
                  icon: Icons.message,
                ),
                ButtonConfig(
                  label: 'Send test message',
                  onTap: _sendTestMessage,
                  icon: Icons.message,
                ),
                ButtonConfig(
                  label: 'Get read receipts',
                  onTap: _getListReadReceipts,
                  icon: Icons.message,
                ),
              ]),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'Get last message messages',
                  onTap: _getLastMessage,
                  icon: Icons.message,
                ),
                ButtonConfig(
                  label: 'Get list of threads',
                  onTap: _getInitialListThreads,
                  icon: Icons.message,
                ),
                ButtonConfig(
                  label: 'Is more threads available',
                  onTap: _isMoreThreadsAvailable,
                  icon: Icons.message,
                ),
              ]),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'Unregister voip push',
                  onTap: _unregisterPushNotifications,
                  icon: Icons.message,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Divider(height: 16),
      ],
    );
  }

  // Create a grid of buttons to save vertical space
  Widget _buildButtonGrid(List<ButtonConfig> buttons) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.8,
      padding: EdgeInsets.only(bottom: 10),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 0,
      crossAxisSpacing: 8,
      children: buttons.map((config) => _buildCompactButton(config)).toList(),
    );
  }

  Widget _buildCompactButton(ButtonConfig config) {
    return ElevatedButton(
      onPressed: config.onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: config.backgroundColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(config.icon, size: 20),
          const SizedBox(height: 4),
          Text(
            config.label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ButtonConfig {
  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;

  ButtonConfig({
    required this.label,
    required this.onTap,
    required this.icon,
    this.backgroundColor = Colors.blue,
  });
}
