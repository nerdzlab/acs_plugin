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
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNV8wMDAwMDAyNy1iNzA1LTQ4ZmUtNmE0OS1hZDNhMGQwMDk3MDIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDg0NDAwMjUiLCJleHAiOjE3NDg1MjY0MjUsInJnbiI6ImRlIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6IjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNSIsInJlc291cmNlTG9jYXRpb24iOiJnZXJtYW55IiwiaWF0IjoxNzQ4NDQwMDI1fQ.Qq88oHaboBx1Vd5YCaUV-uLLkW1SZJp2p9p5Vpu9sfG8HWBKJKd5EIac7NcNeR5vF5bhCdHeiuMZSubmLaNiqVvuwpx1RQI8KDUmSTKaQNZkCqMzzfjiC35wN4pa9R9T688GemQn3XUNWVtOSyZ5tjrEdEhtxfsGeCHkm20S2zJURN8n86hemRaaTKpbm9mQA67hHPmN8ZRcNFpLvK-zr8WWqD3r0rRGWxN5XLKz14qo-dgv92eKWXIb_xvnX1NKiSQEHsMYr77IWAHelrotKsIvCLMB2i_rJLCOA4YotA10q4x5lgaHkRTLEVWa_b2Ow_VIsY2RV5Opauq7y4GZDA";
    } else {
      return "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNV8wMDAwMDAyNy1iNzA5LWZkMzAtNDY2Ny00NDNhMGQwMDllOGEiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDg0NDAyODkiLCJleHAiOjE3NDg1MjY2ODksInJnbiI6ImRlIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6IjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNSIsInJlc291cmNlTG9jYXRpb24iOiJnZXJtYW55IiwiaWF0IjoxNzQ4NDQwMjg5fQ.xA2pgTq7jaYCQJGmqrx_Zhs7WgM6dD7DV21ZT_2HHPQt0jF0OjRARkDuZppyh7a1XRBkKFCKDhCpqH3XlfbSHR-G1Zmf1P31mW2cYmAoXJK7EhCJJxKldWdOmrFCgJZFbp-c13IrlWgABME81GzUHxRr4tqCLar61oMC6qZ5frZgHGLJsUXpp4-KoDwIAng3D-EwZ3qpZ8mfbFT8Ks2402BuihXf2b7FUM_laAo5EXSx871RrTlM92abGpJ7y337lAPnE99q8YYejSx1CLxEwb23td1V4A5zSZql2BbhEX6BV3fH8uKOm0LWumgZLICPDtet6_4SKE4YTU2f7vf_Yw";
    }
  }

  static const String _roomId = "9957178206609649";

  String get _userId {
    if (isRealDevice) {
      return "8:acs:6d1413cf-2d24-4191-a570-11da916e8425_00000027-b705-48fe-6a49-ad3a0d009702";
    } else {
      return "8:acs:6d1413cf-2d24-4191-a570-11da916e8425_00000027-b709-fd30-4667-443a0d009e8a";
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
