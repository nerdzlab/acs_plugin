import 'dart:developer';

import 'package:acs_plugin_example/participant.dart';
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
  List<Participant> _participants = [];

  StreamSubscription? _eventsSubscription;

  // Configuration constants - move to a config file in a real app
  static const String _acsToken =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IkY1M0ZEODA0RThBNDhBQzg4Qjg3NTA3M0M4MzRCRDdGNzBCMzBENDUiLCJ4NXQiOiI5VF9ZQk9pa2lzaUxoMUJ6eURTOWYzQ3pEVVUiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDM2NzExMDUiLCJleHAiOjE3NDM3NTc1MDUsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDM2NzExMDV9.ixd6574qA0b-Zg9UOlYT68zV8AGWR5U9HmI2l9XbTGeaZv4113rPRUBffSBM4BTjHo66khcP-P0ubnws6qOTR2Y-D6N2l2kQH3G7KByKbs-CADQY4KDdUjTYDNHIllty6YVnm9rZRMfhDwMfuW3-e-_Dv1ICjXdNWWMSb01iV4GxICm4Rvrvrxl9P8_kv7YMPNcdcL0PzTGtO5rbl0J04uovx2XDYNuW_z-pWCJ3MCpa0Jm4x8jvS8yJBKL2dMMBXSeMZPJXpthfTcspHapWeYAgub7yy-REL2nrtdxY-XqSBIWdue81BnHM-U9fLi9IRd8QRHWCqTwBTnWZPsjWVw";
  static const String _roomId = "99537223093283920";

  @override
  initState() {
    super.initState();
    _getPlatformVersion();

    // Subscribe to event stream
    _eventsSubscription = _acsPlugin.eventStream.listen(
      _handleEvent,
      onError: _handleError,
      cancelOnError: false,
    );
  }

// Handle incoming events
  _handleEvent(dynamic event) {
    final String eventName = event['event'];

    switch (eventName) {
      case 'preview':
        _handlePreviewEvent(event);
        break;
      case 'participant_list':
        _handleParticipantList(event);
        break;
      // Add more cases as needed
      default:
        log('Unhandled event type: $eventName');
        break;
    }
  }

  // Handle preview event
  _handlePreviewEvent(Map<dynamic, dynamic> event) {
    final viewId = event['viewId'];

    setState(() {
      _viewId = viewId;
      _isVideoOn = viewId != null;

      if (!_isVideoOn) {
        log('Received nil viewId from iOS');
      } else {
        log('Received viewId from iOS: $viewId');
      }

      _showSnackBar('Video toggled: ${_isVideoOn ? 'on' : 'off'}');
    });
  }

  // Handle participant list event
  _handleParticipantList(Map<dynamic, dynamic> event) {
    final participants = event['participants'] as List;

    final participantList = participants
        .whereType<Map>()
        .map((participantMap) =>
            Participant.fromMap(participantMap.cast<String, dynamic>()))
        .toList();

    setState(() {
      _participants = participantList;
    });

    log('Received ${participantList.length} participants');
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
      case 'PREVIEW_ERROR':
        setState(() {
          _isVideoOn = false;
          _viewId = null;
          _showSnackBar('Video toggled: ${_isVideoOn ? 'on' : 'off'}');
        });
        break;
      case 'CALL_ERROR':
        setState(() {
          _isVideoOn = false;
          _viewId = null;
          _showSnackBar('${error.message}');
        });
      default:
        log('Unhandled error code: ${error.code}');
        // Handle other errors
        break;
    }
  }

  // Helper method for showing snackbars (fixed typo from original)
  _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
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
  Future<void> _initAzure() async {
    try {
      await _acsPlugin.initializeCall(token: _acsToken);
      log('Azure Communication Services initialized successfully');
      _shwoSnacBar('Azure Communication Services initialized successfully');
    } on PlatformException catch (error) {
      log('Failed to initialize ACS: ${error.message}');
      _shwoSnacBar('Failed to initialize ACS: ${error.message}');
    }
  }

  Future<void> _joinRoom() async {
    try {
      await _acsPlugin.joinRoom(roomId: _roomId);
      log('Joined room successfully');
      _shwoSnacBar('Joined room successfully');
    } on PlatformException catch (error) {
      log('Failed to join room: ${error.message}');
      _shwoSnacBar('Failed to join room: ${error.message}');
    }
  }

  Future<void> toggleParticipantVideo(String participantId) async {
    try {
      await _acsPlugin.toggleParticipantVideo(participantId);
      log('Toggled participant video successfully');
      _shwoSnacBar('Joined room successfully');
    } on PlatformException catch (error) {
      log('Failed to toggle participant $participantId video: ${error.message}');
      _shwoSnacBar(
          'Failed to toggle participant $participantId video: ${error.message}');
    }
  }

  Future<void> _leaveRoom() async {
    try {
      await _acsPlugin.leaveRoomCall();
      log('Left room successfully');
      _shwoSnacBar('Left room successfully');
    } on PlatformException catch (error) {
      log('Failed to leave room: ${error.message}');
      _shwoSnacBar('Failed to leave room: ${error.message}');
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
      _shwoSnacBar('Call is muted: $result');
    } on PlatformException catch (error) {
      log('Failed to toggle mute: ${error.message}');
      _shwoSnacBar('Failed to toggle mute: ${error.message}');
    }
  }

  Future<void> _toggleSpeaker() async {
    try {
      final result = await _acsPlugin.toggleSpeaker();
      setState(() {
        _isSpeakerOn = result;
      });
      log('Speaker is enabled: $result');
      _shwoSnacBar('Speaker is enabled: $result');
    } on PlatformException catch (error) {
      log('Failed to toggle speaker: ${error.message}');
      _shwoSnacBar('Failed to toggle speaker: ${error.message}');
    }
  }

  Future<void> _toggleVideo() async {
    try {
      await _acsPlugin.toggleLocalVideo();
    } on PlatformException catch (error) {
      log('Failed to toggle video: ${error.message}');
      _shwoSnacBar('Failed to toggle video: ${error.message}');
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
                        child: IosVideoView(
                          viewId: _viewId!,
                          viewType: "self_preview",
                        ),
                      )
                    : const Center(
                        child: Text(
                          'No video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
              // Participants section
              if (_participants.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildSectionHeader('Participants'),
                SizedBox(
                  height: 200,
                  child: _buildParticipantGrid(),
                ),
              ],
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

  Widget _buildParticipantGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _participants.length,
      itemBuilder: (context, index) {
        final participant = _participants[index];
        return _buildParticipantVideo(participant);
      },
    );
  }

  Widget _buildParticipantVideo(Participant participant) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Video view
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: participant.hasVideo
                ? IosVideoView(
                    viewId: participant.rendererViewId ?? '',
                    viewType: "participant_preview",
                  )
                : const Center(
                    child: Icon(
                      Icons.videocam_off,
                      color: Colors.white54,
                      size: 40,
                    ),
                  ),
          ),

          // Participant name overlay
          Positioned(
            left: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                participant.displayName ?? 'Unknown',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IosVideoView extends StatelessWidget {
  final String viewId;
  final String viewType;

  const IosVideoView({
    super.key,
    required this.viewId,
    required this.viewType,
  });

  @override
  Widget build(BuildContext context) {
    return UiKitView(
      viewType: 'acs_video_view',
      creationParams: {
        'view_id': viewId,
        "view_type": viewType,
      },
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
