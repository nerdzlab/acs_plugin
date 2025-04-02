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
  List<Participant> _participants = [];

  StreamSubscription? _eventsSubscription;

  // Configuration constants - move to a config file in a real app
  static const String _acsToken =
      "eyJhbGciOiJSUzI1NiIsImtpZCI6IkY1M0ZEODA0RThBNDhBQzg4Qjg3NTA3M0M4MzRCRDdGNzBCMzBENDUiLCJ4NXQiOiI5VF9ZQk9pa2lzaUxoMUJ6eURTOWYzQ3pEVVUiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZV8wMDAwMDAyNi03MWQyLWIxYmUtYTdhYy00NzNhMGQwMDA2YzIiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDM0OTQzODUiLCJleHAiOjE3NDM1ODA3ODUsInJnbiI6Im5vIiwiYWNzU2NvcGUiOiJ2b2lwIiwicmVzb3VyY2VJZCI6Ijg2N2E1ZGMwLWJjZGYtNGRjNy04NjBmLTNmYzMzZDJhM2ZlZSIsInJlc291cmNlTG9jYXRpb24iOiJub3J3YXkiLCJpYXQiOjE3NDM0OTQzODV9.PuhSLX3_uG7AisLEQHagfM-JmbK4QKduVEJrl8Dzo-l9KSgPyD5GH17l9AQU-C8ZDb40BEHQU1tEfFwvvS9PS_biKUp0zLNC7Vm6J5eJZ-_fL2He63YIyjdIZAz11-tXIOqdNHnpE6NJrhLGrKrWv0PrLO7bcpCnD9EDoGXqcyTiw2j5h3vCj13dN4SkGJr3qCrKicoD2cZsFMQGAQtINfqRZUtkFIg1rYodv1RFX69X457BEurj_6y9szFh82ifLzu7sv-8WKe07jCC4mWGNhImnIL99t4J-ty_HZfKc_zLSNa3bc4qhwHB0T7u0_H-oWey2HE2FBSxwEg63MEoUg";
  static const String _roomId = "99530934209225207";

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
      case 'participantList':
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

    // Convert to your participant model objects
    final List<Participant> participantList = participants
        .map((participantMap) =>
            Participant.fromMap(participantMap as Map<String, dynamic>))
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

class Participant {
  final String displayName;
  final String mri;
  final bool isMuted;
  final bool isSpeaking;
  final bool hasVideo;
  final bool videoOn;
  final String state;
  final String scalingMode;
  final String? rendererViewId;

  Participant({
    required this.displayName,
    required this.mri,
    required this.isMuted,
    required this.isSpeaking,
    required this.hasVideo,
    required this.videoOn,
    required this.state,
    required this.scalingMode,
    this.rendererViewId,
  });

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      displayName: map['displayName'] as String,
      mri: map['mri'] as String,
      isMuted: map['isMuted'] as bool,
      isSpeaking: map['isSpeaking'] as bool,
      hasVideo: map['hasVideo'] as bool,
      videoOn: map['videoOn'] as bool,
      state: map['state'] as String,
      scalingMode: map['scalingMode'] as String,
      rendererViewId: map['rendererViewId'] as String?,
    );
  }

  // Helper method to get participant's state as enum if needed
  ParticipantState get participantState => participantStateFromString(state);

  // Helper method to get scaling mode as enum if needed
  ScalingMode get participantScalingMode =>
      _getScalingModeFromString(scalingMode);

  // Optional: Convert back to map if needed for any reason
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'mri': mri,
      'isMuted': isMuted,
      'isSpeaking': isSpeaking,
      'hasVideo': hasVideo,
      'videoOn': videoOn,
      'state': state,
      'scalingMode': scalingMode,
      'rendererViewId': rendererViewId,
    };
  }

  @override
  String toString() {
    return 'Participant(displayName: $displayName, mri: $mri, isMuted: $isMuted, isSpeaking: $isSpeaking, hasVideo: $hasVideo, videoOn: $videoOn, state: $state, scalingMode: $scalingMode, rendererViewId: $rendererViewId)';
  }
}

// You'll need to create these enums to match your Swift enums
enum ParticipantState {
  idle, // ACSParticipantStateIdle
  earlyMedia, // ACSParticipantStateEarlyMedia
  connecting, // ACSParticipantStateConnecting
  connected, // ACSParticipantStateConnected
  hold, // ACSParticipantStateHold
  inLobby, // ACSParticipantStateInLobby
  disconnected, // ACSParticipantStateDisconnected
  ringing, // ACSParticipantStateRinging
}

enum ScalingMode {
  fit,
  crop,
  // Add more scaling modes as needed based on your Swift enum
}

// Helper functions to convert string values to enum values
String participantStateToString(ParticipantState state) {
  switch (state) {
    case ParticipantState.idle:
      return 'Idle';
    case ParticipantState.earlyMedia:
      return 'Early Media';
    case ParticipantState.connecting:
      return 'Connecting';
    case ParticipantState.connected:
      return 'Connected';
    case ParticipantState.hold:
      return 'On Hold';
    case ParticipantState.inLobby:
      return 'In Lobby';
    case ParticipantState.disconnected:
      return 'Disconnected';
    case ParticipantState.ringing:
      return 'Ringing';
  }
}

ParticipantState participantStateFromString(String stateString) {
  switch (stateString.toLowerCase()) {
    case 'idle':
      return ParticipantState.idle;
    case 'early media':
      return ParticipantState.earlyMedia;
    case 'connecting':
      return ParticipantState.connecting;
    case 'connected':
      return ParticipantState.connected;
    case 'on hold':
      return ParticipantState.hold;
    case 'in lobby':
      return ParticipantState.inLobby;
    case 'disconnected':
      return ParticipantState.disconnected;
    case 'ringing':
      return ParticipantState.ringing;
    default:
      throw ArgumentError('Unknown state string: $stateString');
  }
}

ScalingMode _getScalingModeFromString(String value) {
  switch (value) {
    case 'fit':
      return ScalingMode.fit;
    case 'crop':
      return ScalingMode.crop;
    // Add more cases as needed
    default:
      return ScalingMode.fit; // Default value
  }
}
