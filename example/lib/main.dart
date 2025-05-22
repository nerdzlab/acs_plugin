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
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNy05MTY2LWU0ZWEtOTE4ZS1hZjNhMGQwMDI2N2IiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDc4OTc1NjUiLCJleHAiOjE3NDc5ODM5NjUsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDc4OTc1NjV9.bJcj7TzvIDSQoM65P3ddXAdM8o8VTmR8yyF2pJZM-pI9rVax0KJ17-9NqjqWHErfgpnMdkipDQF1vgwtOJBw04iK_JOACNeYVOcZcRnzKNj-jllR5WYbSr2wYlnLay85qlymGq2Do7e8ITLYlEXQWSKcbn81t_c85yvceJpQYgAgSCIN72qHwpwXnZaYvJKMcE32qTP3LJQC8HkQSgKStq4qe3OjOKUOeWiooPndu-IEmsvNPIb7rgpOtOV4y3LzUstmo1g7dS1nOY-Yxq7TWvYe-S9cXK6X0wh7LxFp2ncTrsGW6V7X8MyqmDsHJAp_eeiEJZ83w9wTQK8TRVUpdQ";
    } else {
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNy05MTgyLTQ5NTItMzRmYS1hZDNhMGQwMDQ5YjkiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDc4OTczMjYiLCJleHAiOjE3NDc5ODM3MjYsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDc4OTczMjZ9.j4i6kfJqDfagEdEley-_LXyck6DUEWM1PeOZQQzJzQriNMqh1NDOcTYiyjMWKzqkqvurzTSIMQB0ND1Wdaqb1E8XulNMFUhQUgumPNke2XA1TQcVwJaWgwuTto0AnFsQ7G58ObaXL3TOaUr-qn8w2U3vWPt-fAz3oZnyL0YfWkNX4QvyeU82nZ4OEGC81_7lqTDaWxzMpT9bee7xrmw9YAdoL0ciHxVvGaQ9hQ_ZoLLa-R8RTz9KATkEFAAls90dMpIkt5o_UghIfny6KRgY7xTcscGhbf4z5DnikdvfNEjX28kzl_XF961L-mmLIuacF7ijly15VZHl_dmuR_Z3-g";
    }
  }

  static const String _roomId = "99584500555056841";

  String get _userId {
    if (isRealDevice) {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000027-9166-e4ea-918e-af3a0d00267b";
    } else {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000027-9182-4952-34fa-ad3a0d0049b9";
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
