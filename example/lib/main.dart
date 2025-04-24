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
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDU0Nzc2OTIiLCJleHAiOjE3NDU1NjQwOTIsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDU0Nzc2OTJ9.potXYt_lbnLDd5mca0q-3cN2aUeIyOkK-U6It_Y4baXAgNZ7X2E-a0I7BgGrlBUeGopoyMqAnpVHniNtNlfBC_JMp6cADikfjrZnwHOGZKX8zyMNIhYPZRbA5wF4Oduh7qCzyup0pjaVIYU3YZJmr8RBXYiPsQnVikw-i5QBPd0GI6yUcc9AO6HhMAlUoZp1SZz9m68O-W_rn5LlcltWwLm4THDQHYNzuppfuC5craVjzGPtvtXbOjzb4OSzYSF0yDRFX0N_qnaRYr1ZUpNWiBhNtAskEJC1ORE_mAUGfTzqB6G4PAY4_vWFs2HXx6SOX76OhOwry-IPw74YrryR2Q";
    } else {
      // return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi05MWFmLWU3YWEtM2Y4Mi1hZjNhMGQwMGIzZDIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDU0Nzc3MjMiLCJleHAiOjE3NDU1NjQxMjMsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDU0Nzc3MjN9.pq-pd4OnhPNZH0l1BILiVfHBnXU1TeLs45xU8z6ocF4-ZK6VBSSvBcyKJdv6NMO3t8APoC3mVGY_G5FSGYtu-oGPVSYxBtoj5fKfwHhl80eyGyAheDx5UqVs50mCA-stEEYPw4SYABr7jQg8vJW4nO3tY56Ay3utwJye3jDZ_ji0VK9p2-cG2aQUPDH9Aov0cWiOq5J2Ly7mP9eb80g2qUi9wly1gMCE4_FVz8oqmcLVU3BN_wQV32Ds_YuXDERQW7478eXthkGk49uK8qxXpJtBm_wKWQaZVR9eunth2BEiacJzfqvqkhjtEQcojxkivwte9eYFN8dd8E183JnTQw";
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi1iOTNlLWVjYzktYTdhYy00NzNhMGQwMDZhMWEiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDU0Nzc3NDQiLCJleHAiOjE3NDU1NjQxNDQsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDU0Nzc3NDR9.AyTusvjUnTrkCNRGYEQi86_mTFdszugzN0mWPtjDbOSjFA30Wx9lOg9TuiU6uVS7qkFv0nc3Gm2ZUhaQXIJlIQ2-IhzEuBEANdgReC83742RCpWL4So947iV0xA8qOXjImNwklW-U1IshMGiNf69hcY4lXtfg9Bvcz6-TAcMb67zkTwp0H5dDDKAp3ZZyyyhPf3ppXp-9yJLLcHFvGjpYulz3EdpsqGCcVkgXHKQpwIT0ull8D65MD80x5jfSOj6-s0uPCxOIGxZGC3HtLj72L5w-iARiX8nNJ4GG53JyH5mZQoqAMRCEMZFSVinTt4P47Bp0anlxeubmrTQ-tryBA";
    }
  }

  static const String _roomId = "9958333897200100";

  String get _userId {
    if (isRealDevice) {
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000026-71d2-b1be-a7ac-473a0d0006c2";
    } else {
      // return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi05MWFmLWU3YWEtM2Y4Mi1hZjNhMGQwMGIzZDIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDU0Nzc3MjMiLCJleHAiOjE3NDU1NjQxMjMsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDU0Nzc3MjN9.pq-pd4OnhPNZH0l1BILiVfHBnXU1TeLs45xU8z6ocF4-ZK6VBSSvBcyKJdv6NMO3t8APoC3mVGY_G5FSGYtu-oGPVSYxBtoj5fKfwHhl80eyGyAheDx5UqVs50mCA-stEEYPw4SYABr7jQg8vJW4nO3tY56Ay3utwJye3jDZ_ji0VK9p2-cG2aQUPDH9Aov0cWiOq5J2Ly7mP9eb80g2qUi9wly1gMCE4_FVz8oqmcLVU3BN_wQV32Ds_YuXDERQW7478eXthkGk49uK8qxXpJtBm_wKWQaZVR9eunth2BEiacJzfqvqkhjtEQcojxkivwte9eYFN8dd8E183JnTQw";
      return "8:acs:867a5dc0-bcdf-4dc7-860f-3fc33d2a3fee_00000026-b93e-ecc9-a7ac-473a0d006a1a";
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
