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
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNy0zMDllLWVlOTQtMDU4Ni1hZjNhMGQwMDhiZmEiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDYxODUwNDYiLCJleHAiOjE3NDYyNzE0NDYsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDYxODUwNDZ9.DCj8wQlPdNdZuIeVPoBW0Jg9a6h2BDNQhB1s9U70MSDRUJkAACQJLtFoYnQY6NpvFUvjTyUeZd0pqHcOuQV-b0pcTRhCCsedb8KlPHMoyHIrdb7oNiVrZdhc7g1xxnZDKFEg6le-p1t1242RK-_TaRZFpkM2uMe--K4JB5ilK81el3r19AY6s1FIlEg71-tSiarX71Rze60KbeZmNYno281Lh5WEUxMvvmXq5POHAH96C3WU0BFgfq_PIJHF2mwOenGer9hEuD1jBrySOZYGdVgmwShr62jF61h-UF0Wc7qH20VAdoLLtIXdMyHYjo9AU-OuxUz40NP1DGqBiRI68w";
    } else {
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi05MWFmLWU3YWEtM2Y4Mi1hZjNhMGQwMGIzZDIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDYxNzA4NDQiLCJleHAiOjE3NDYyNTcyNDQsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDYxNzA4NDR9.cfDZbw_4SYhTWlXC66iH2MBMXK504mttx_UwrJu4yc3DCP1L3VZxQlwCHwSZYUGb3gANRu4bvxSoVG8yMI8SNkVSJtpL9IWPkQI0A-2QFBShYbUg82ANv7OPFk6qAjqkybkqaxc7vINwckJf7aUbODZboK4JZoyVvPQHNdaxVhXz1KapJ3fgugsyK5X6yEyQOMfZyWJxKPalALZXo3lVVmp8GQHtQ6lObg0HUfISFp3vyxDZLqyu4Olbha4Puxl7mUW8ztY1tUBC0QgNwqp6P6zzFd8vWsDMPpUKMmeTaIZ9xX-I_PzY_AtYUH02Gv4Ruu2qETwMaxhOIlUMt9CF6A";
    }
  }

  static const String _roomId = "99594083154089769";

  String get _userId {
    if (isRealDevice) {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000027-309e-ee94-0586-af3a0d008bfa";
    } else {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000027-2aec-a2ce-59fe-ad3a0d00df36";
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
