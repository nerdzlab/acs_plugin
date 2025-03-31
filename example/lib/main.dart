import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:acs_plugin/acs_plugin.dart';

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
  String? _viewId;
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isVideoOn = false;

  // Configuration constants - move to a config file in a real app
  static const String _acsToken =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IkY1M0ZEODA0RThBNDhBQzg4Qjg3NTA3M0M4MzRCRDdGNzBCMzBENDUiLCJ4NXQiOiI5VF9ZQk9pa2lzaUxoMUJ6eURTOWYzQ3pEVVUiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDM0MTEyMTUiLCJleHAiOjE3NDM0OTc2MTUsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDM0MTEyMTV9.EkuqQKM99Lz6kZ7P2sWYhxGmj9vYRnhxijO-Uk6H104GWRqGjC9Lw7IU-xZtkBhFqF84-yED2w64oiF_QvvP07FjjgMKUjW1XvDftfVrs-RvR3pHE99G96GwIuJFt7Emd__3mNMkLUdP87GAu-SgZkUyo24s58pK_-zmidbyjwmOeOMyFplukA4VHuY_zd4v1BT1IaRvEJgQKDRvcptSTi268Igi4x-xHHq_X7SzLPNt7SDtkisUl6VI58Hapr6QHZUQAn_wZ4asLCbmTiRIKkdKHuhd21q06NdS1mSxZyRmXLNqELsulpiP4h00zSk_9AWCv6uoTiTse02RqAYFTA";
  static const String _roomId = "99547464766727963";

  @override
  void initState() {
    super.initState();
    _getPlatformVersion();
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
    } catch (error) {
      log('Microphone permission error: $error');
    }
  }

  Future<void> _requestCameraPermissions() async {
    try {
      final result = await _acsPlugin.requestCameraPermissions();
      log('Camera permissions granted: $result');
    } catch (error) {
      log('Camera permission error: $error');
    }
  }

  // Call management methods
  Future<void> _initAzure() async {
    try {
      await _acsPlugin.initializeCall(token: _acsToken);
      log('Azure Communication Services initialized successfully');
    } catch (error) {
      log('Failed to initialize ACS: $error');
    }
  }

  Future<void> _joinRoom() async {
    try {
      await _acsPlugin.joinRoom(roomId: _roomId);
      log('Joined room successfully');
    } catch (error) {
      log('Failed to join room: $error');
    }
  }

  Future<void> _leaveRoom() async {
    try {
      await _acsPlugin.leaveRoomCall();
      setState(() {
        _viewId = null;
        _isVideoOn = false;
      });
      log('Left room successfully');
    } catch (error) {
      log('Failed to leave room: $error');
    }
  }

  // Media control methods
  Future<void> _toggleMute() async {
    try {
      final result = await _acsPlugin.toggleMute();
      setState(() {
        _isMuted = result;
      });
      log('Call is muted: $result');
    } catch (error) {
      log('Failed to toggle mute: $error');
    }
  }

  Future<void> _toggleSpeaker() async {
    try {
      final result = await _acsPlugin.toggleSpeaker();
      setState(() {
        _isSpeakerOn = result;
      });
      log('Speaker is enabled: $result');
    } catch (error) {
      log('Failed to toggle speaker: $error');
    }
  }

  Future<void> _toggleVideo() async {
    try {
      String? viewId = await _acsPlugin.toggleLocalVideo();
      setState(() {
        _viewId = viewId;
        _isVideoOn = viewId != null;
      });
      log('Video toggled: ${_isVideoOn ? 'on' : 'off'}');
    } catch (error) {
      log('Failed to toggle video: $error');
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
                  label: 'Init Azure',
                  onTap: _initAzure,
                  icon: Icons.cloud,
                ),
              ]),
              // Call Management Section
              _buildSectionHeader('Call Management'),
              _buildButtonGrid([
                ButtonConfig(
                  label: 'Join Room',
                  onTap: _joinRoom,
                  icon: Icons.call,
                ),
                ButtonConfig(
                  label: 'Leave Room',
                  onTap: _leaveRoom,
                  icon: Icons.call_end,
                  backgroundColor: Colors.red,
                ),
              ]),
              // Media Controls Section
              _buildSectionHeader('Media Controls'),
              _buildButtonGrid([
                ButtonConfig(
                  label: _isMuted ? 'Unmute' : 'Mute',
                  onTap: _toggleMute,
                  icon: _isMuted ? Icons.mic_off : Icons.mic,
                ),
                ButtonConfig(
                  label: _isSpeakerOn ? 'Speaker Off' : 'Speaker On',
                  onTap: _toggleSpeaker,
                  icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_off,
                ),
                ButtonConfig(
                  label: _isVideoOn ? 'Video Off' : 'Video On',
                  onTap: _toggleVideo,
                  icon: _isVideoOn ? Icons.videocam : Icons.videocam_off,
                ),
              ]),

              const SizedBox(height: 12),

              // Video Preview
              _buildSectionHeader('Video Preview'),
              Container(
                height: 240,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _viewId != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: IosVideoView(viewId: _viewId!),
                      )
                    : const Center(
                        child: Text(
                          'No video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
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

class IosVideoView extends StatelessWidget {
  final String viewId;

  const IosVideoView({super.key, required this.viewId});

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: 'acs_video_view',
      creationParams: {'viewId': viewId},
      creationParamsCodec: const StandardMessageCodec(),
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
