final class Participant {
  final String displayName;
  final String mri;
  final bool isMuted;
  final bool isSpeaking;
  final bool hasVideo;
  final bool videoOn;
  final int state;
  final int scalingMode;
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
      state: map['state'] as int,
      scalingMode: map['scalingMode'] as int,
      rendererViewId: map['rendererViewId'] as String?,
    );
  }

  // Helper method to get participant's state as enum if needed
  ParticipantState get participantState => participantStateFromInt(state);

  // Helper method to get scaling mode as enum if needed
  ScalingMode get participantScalingMode => _getScalingModeFromInt(scalingMode);

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
}

// Helper functions to convert string values to enum values
int participantStateToInt(ParticipantState state) {
  switch (state) {
    case ParticipantState.idle:
      return 0;
    case ParticipantState.earlyMedia:
      return 1;
    case ParticipantState.connecting:
      return 2;
    case ParticipantState.connected:
      return 3;
    case ParticipantState.hold:
      return 4;
    case ParticipantState.inLobby:
      return 5;
    case ParticipantState.disconnected:
      return 6;
    case ParticipantState.ringing:
      return 7;
  }
}

ParticipantState participantStateFromInt(int state) {
  switch (state) {
    case 0:
      return ParticipantState.idle;
    case 1:
      return ParticipantState.earlyMedia;
    case 2:
      return ParticipantState.connecting;
    case 3:
      return ParticipantState.connected;
    case 4:
      return ParticipantState.hold;
    case 5:
      return ParticipantState.inLobby;
    case 6:
      return ParticipantState.disconnected;
    case 7:
      return ParticipantState.ringing;
    default:
      throw ArgumentError('Unknown state: $state');
  }
}

ScalingMode _getScalingModeFromInt(int value) {
  switch (value) {
    case 1:
      return ScalingMode.crop;
    case 2:
      return ScalingMode.fit;
    default:
      return ScalingMode.fit; // Default value
  }
}
