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
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNy05YzNjLWQyNjQtODc0YS1hZDNhMGQwMGUyMzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDgzNjA5MzIiLCJleHAiOjE3NDg0NDczMzIsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDgzNjA5MzJ9.ZRq-fc6myDGCHeJuDEJzRhBP5u0yPSBNnVluMf0qhx7pVPzFjKs0hLI24VQ1NwbIVSuZTSQ4TSzsGXJTVIUZN1iFZ4z6GganGpoD9sFvpQTbC48zBh2bU2YgtcGj4EoVqXQe3Pu78z-QFItETDIIhd8gMP7htquYzj9qYP6VZsUy1cSpDx7qxBKX9PlCgJTrVKluGupcUR5Eteovly5U7Tj7jhPGzI1KwQ2jX02fTpndhETZ7u7CkBg5JdNXWjps0EsuOBGufKnV7_qTf7vzvp40Uq0gI-HX0o2s02UY8LNxz4st8OeqwFuIBq-2pSZMZvgkO26dtpRovjuE7Xgmvw";
    } else {
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNy05YzQwLWQyMjAtODc0YS1hZDNhMGQwMGUzNzgiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDgzNjA2MzMiLCJleHAiOjE3NDg0NDcwMzMsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDgzNjA2MzN9.AKiajZ_NOnUHBqYk-A_QyuOAqTUylPovb18C0z5spQee7JeI8PSIAQB73RIKeNdNaCcF3l3xAPboVQ5nOzMCC48HSBXbyFVLGT646K9YOKSRvFdB7Oa2zVTIV5z6YFdLlJ1k5kH1sJZY4OctIUbEL9fyR7d7CH7gJbkh3KFor0iZ85d2GZ3TF3idtw6b4tNO4ECiDUvIu1AZRzyr3MCVMpxJMmvOC1g2Pt6Finndm1yIlFCYiHGTJRO7l40hnygrzEkzkxKQK_SFoFiy86XCGCvdm0MKUjHqmuqGorheAFO2lB1Po_Z7v5F2A_sSIEUj0pts5y4oQrHUQClOKPCgvw";
    }
  }

  static const String _roomId = "99524064438992204";

  String get _userId {
    if (isRealDevice) {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000027-9c3c-d264-874a-ad3a0d00e232";
    } else {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000027-9c40-d220-874a-ad3a0d00e378";
    }
  }

  @override
  initState() {
    super.initState();
    _getPlatformVersion();

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
  }

// Handle incoming events
  _handleEvent(dynamic event) {
    final String eventName = event['event'];

    switch (eventName) {
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
          token: _acsToken, roomId: _roomId, userId: _userId);
      log('Room call initialized successfully');
      _shwoSnacBar('Room call initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize room call: ${error.message}');
      _shwoSnacBar('Failed to initialize room call: ${error.message}');
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
