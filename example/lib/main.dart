import 'dart:developer';

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

  StreamSubscription? _eventsSubscription;

  // Configuration constants - move to a config file in a real app
  String get _acsToken {
    if (isRealDevice) {
      return Constants.userOneToken;
    } else {
      return Constants.userTwoToken;
    }
  }

  static const String _roomId = Constants.roomId;
  static const _appGroupIdentifier = Constants.appGroupIdentifier;
  static const _extensionBundleId = Constants.extensionBundleId;

  static const String _endpoint = Constants.enpoint;
  static const String _threadId = Constants.threadId;

  String get _userId {
    if (isRealDevice) {
      return Constants.userOneId;
    } else {
      return Constants.userTwoId;
    }
  }

  String get _otherUserId {
    if (isRealDevice) {
      return Constants.userTwoId;
    } else {
      return Constants.userOneId;
    }
  }

  @override
  initState() {
    super.initState();
    _setBroadcastExtensionData();
    _setDeviceType();

    // Subscribe to event stream
    _eventsSubscription = _acsPlugin.eventStream.listen(
      _handleEvent,
      onError: _handleError,
      cancelOnError: false,
    );
  }

  _setDeviceType() async {
    isRealDevice = await SafeDevice.isRealDevice;
    _setUserData();
  }

// Handle incoming events
  _handleEvent(dynamic event) {
    final String eventName = event['event'];

    switch (eventName) {
      case 'onShowChat':
        _shwoSnacBar("Show chat");

      case 'onCallUIClosed':
        _shwoSnacBar("Call ui closed");

      case 'onPluginStarted':
        _shwoSnacBar("Plugin started");

      case 'onUserCallEnded':
        _shwoSnacBar("User ended call");

      default:
        log('Unhandled event type: $eventName');
        break;
    }
  }

  // Handle stream errors
  _handleError(dynamic error) {
    if (error is PlatformException) {
      log('Error code: ${error.code}');
      log('Error message: ${error.message}');
      log('Error details: ${error.details}');

      _handlePlatformError(error);
    } else {
      log('Non-platform error: $error');
    }
  }

// Handle platform-specific errors
  _handlePlatformError(PlatformException error) {
    switch (error.code) {
      default:
        log('Unhandled error code: ${error.code}');
        // Handle other errors
        break;
    }
  }

  @override
  dispose() {
    _eventsSubscription?.cancel();
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

  // Permission methods
  Future<void> _requestMicrophonePermissions() async {
    try {
      final result = await _acsPlugin.requestMicrophonePermissions();
      log('Microphone permissions granted: $result');
      _shwoSnacBar("Microphone permissions granted: $result");
    } on PlatformException catch (error) {
      log('Microphone permission error: ${error.message}');
    }
  }

  Future<void> _requestCameraPermissions() async {
    try {
      final result = await _acsPlugin.requestCameraPermissions();
      log('Camera permissions granted: $result');
      _shwoSnacBar('Camera permissions granted: $result');
    } on PlatformException catch (error) {
      log('Camera permission error: ${error.message}');
      _shwoSnacBar('Camera permission error: ${error.message}');
    }
  }

  // Call management methods
  Future<void> initializeRoomCall() async {
    try {
      await _acsPlugin.initializeRoomCall(
        token: _acsToken,
        roomId: _roomId,
        userId: _userId,
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

  // One on one call methods
  Future<void> _startOneOnOneCall() async {
    try {
      await _acsPlugin.startOneOnOneCall(
        token: _acsToken,
        participantId: _otherUserId,
        userId: _userId,
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
        name: "Yra",
        userId: _userId,
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

  Future<void> _setupChat() async {
    try {
      await _acsPlugin.setupChat(
        endpoint: _endpoint,
        threadId: _threadId,
      );
      log('Chat initialized successfully');
      _shwoSnacBar('Chat initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize chat: ${error.message}');
      _shwoSnacBar('Failed to initialize chat: ${error.message}');
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
                  label: 'Microphone',
                  onTap: _requestMicrophonePermissions,
                  icon: Icons.mic,
                ),
                ButtonConfig(
                  label: 'Camera',
                  onTap: _requestCameraPermissions,
                  icon: Icons.camera_alt,
                ),
                ButtonConfig(
                  label: 'Init room call',
                  onTap: initializeRoomCall,
                  icon: Icons.cloud,
                ),
              ]),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'One on One call',
                  onTap: _startOneOnOneCall,
                  icon: Icons.mic,
                ),
                ButtonConfig(
                  label: 'Setup chat',
                  onTap: _setupChat,
                  icon: Icons.mic,
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
