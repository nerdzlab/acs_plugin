import 'dart:developer';

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
  String _platformVersion = 'Unknown';
  final _acsPlugin = AcsPlugin();
  bool isRealDevice = false;

  StreamSubscription? _eventsSubscription;

  // Configuration constants - move to a config file in a real app
  String get _acsToken {
    if (isRealDevice) {
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDcwMjkyODYiLCJleHAiOjE3NDcxMTU2ODYsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDcwMjkyODZ9.frxBlGX56-q6Lj0cmbvm725JBmhi4lR97uvzxkiqjsGdjymg-RFTee5NGsqBSFyhTn963ImadoVFMWLjTYAHwpHXsPrVPr0_QcsJUqVhUEDoMaUpgvgFM9TMqIg1mYDRTsy-2xd-g0QLEDJdIVY7vbrPQfv6DDjI66dtp9xKF-_keyuspuH4TyuHTZkE3d7BQPQFNR05jKrnIqcUYyrwW22PrBnTlPG9_prkMu_SXkTSnPUvwODLWRAZR2EtZ7zkyiiacaau5jtYsWBTVOg68jLKT1g-0JZDo4d-VU26fJA2zyoGHRi6Kn8KEN2jX-9Jmn6kV7J6wv1a-VhVyJGKDw";
    } else {
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi05MWFmLWU3YWEtM2Y4Mi1hZjNhMGQwMGIzZDIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDcwMjkzMDUiLCJleHAiOjE3NDcxMTU3MDUsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDcwMjkzMDV9.v1f0KXqWWjH--SUdvRSEWyPE4AMoNqRPsS6MTpkesEsbV7V852zz0zdpW_tHljXxkCVVs5B4kuqD0p6X5j2RKswYEFoNqpX3oSr7GYi0TJPNboxAh4Diz45IB4pdlYTJTDRfTwJczLwRKhDLoGnhNSklsijMhGe53CBAPgTCwN4mX-CYupchxuhPBpgCeS--TIQMx2PPmBTN7b8P3FgECuDVx35MCqxBb0YRVCNXhAsEFTsD1Z0iGRJU8lrflz6Pf3TzBppqawssfMnqK76LIpaU9lfke9tEsTErrQAqqQkKniVoeu5uE6x_dbtksuU8ey-n4Zsk1Sj6fSlqeLB6Ag";
    }
  }

  static const String _roomId = "9955622895914888";
  static const _appGroupIdentifier = "group.acsPluginExample";
  static const _extensionBubdleId =
      "com.example.acsPluginExample.ScreenBroadcast";

  String get _userId {
    if (isRealDevice) {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000026-71d2-b1be-a7ac-473a0d0006c2";
    } else {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000026-91af-e7aa-3f82-af3a0d00b3d2";
    }
  }

  String get _otherUserId {
    if (isRealDevice) {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000026-91af-e7aa-3f82-af3a0d00b3d2";
    } else {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000026-71d2-b1be-a7ac-473a0d0006c2";
    }
  }

  @override
  initState() {
    super.initState();
    _getPlatformVersion();
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

  // Helper methods for platform interactions
  Future<void> _getPlatformVersion() async {
    try {
      final platformVersion =
          await _acsPlugin.getPlatformVersion() ?? 'Unknown platform version';
      if (mounted) {
        setState(() {
          _platformVersion = platformVersion;
        });
      }
    } on PlatformException catch (e) {
      log('Failed to get platform version: ${e.message}');
      if (mounted) {
        setState(() {
          _platformVersion = 'Failed to get platform version';
        });
      }
    }
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
        extensionBubdleId: _extensionBubdleId,
      );
      log('Set broadcast extension data successfully');
      _shwoSnacBar('Set broadcast data successfully');
    } on PlatformException catch (error) {
      log('Failed to set broadcast data: ${error.message}');
      _shwoSnacBar('Failed to set broadcast data: ${error.message}');
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
              Text(
                'Running on: $_platformVersion',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
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
