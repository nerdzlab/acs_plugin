//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine

extension Middleware {
    static func liveCallingMiddleware(callingMiddlewareHandler actionHandler: CallingMiddlewareHandling)
    -> Middleware<AppState, acs_plugin.Action> {
        .init(
            apply: { dispatch, getState in
                return { next in
                    return { action in
                        switch action {
                        case .callingAction(let callingAction):
                            handleCallingAction(callingAction, actionHandler, getState, dispatch)

                        case .localUserAction(let localUserAction):
                            handleLocalUserAction(localUserAction, actionHandler, getState, dispatch)

                        case .permissionAction(let permissionAction):
                            handlePermissionAction(permissionAction, actionHandler, getState, dispatch)

                        case .lifecycleAction(let lifecycleAction):
                            handleLifecycleAction(lifecycleAction, actionHandler, getState, dispatch)

                        case .audioSessionAction(let audioAction):
                            handleAudioSessionAction(audioAction, actionHandler, getState, dispatch)
                        case .remoteParticipantsAction(let action):
                            handleRemoteParticipantAction(action, actionHandler, getState, dispatch)
                        case .captionsAction(let action):
                            handleCaptionsAction(action, actionHandler, getState, dispatch)
                        case .errorAction,
                                .compositeExitAction,
                                .callingViewLaunched:
                            break
                        case .callDiagnosticAction(let action):
                            handleCallDiagnisticAction(action, actionHandler, getState, dispatch)
                        case .toastNotificationAction(let action):
                            handleToastNotificationAction(action, actionHandler, getState, dispatch)
                        default:
                            break
                        }
                        return next(action)
                    }
                }
            }
        )
    }
}

private func handleCallingAction(_ action: CallingAction,
                                 _ actionHandler: CallingMiddlewareHandling,
                                 _ getState: () -> AppState,
                                 _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .setupCall:
        actionHandler.setupCall(state: getState(), dispatch: dispatch)
    case .callStartRequested:
        actionHandler.startCall(state: getState(), dispatch: dispatch)
    case .callEndRequested:
        actionHandler.endCall(state: getState(), dispatch: dispatch)
    case .holdRequested:
        actionHandler.holdCall(state: getState(), dispatch: dispatch)
    case .resumeRequested:
        actionHandler.resumeCall(state: getState(), dispatch: dispatch)
    case .recordingStateUpdated(let isRecordingActive):
        actionHandler.recordingStateUpdated(state: getState(),
                                            dispatch: dispatch,
                                            isRecordingActive: isRecordingActive)
    case .transcriptionStateUpdated(let isTranscriptionActive):
        actionHandler.transcriptionStateUpdated(state: getState(),
                                                dispatch: dispatch,
                                                isTranscriptionActive: isTranscriptionActive)
    default:
        break
    }
}

private func handleLocalUserAction(_ action: LocalUserAction,
                                   _ actionHandler: CallingMiddlewareHandling,
                                   _ getState: () -> AppState,
                                   _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .cameraPreviewOnTriggered:
        actionHandler.requestCameraPreviewOn(state: getState(), dispatch: dispatch)
    case .cameraOnTriggered:
        actionHandler.requestCameraOn(state: getState(), dispatch: dispatch)
    case .cameraOffTriggered:
        actionHandler.requestCameraOff(state: getState(), dispatch: dispatch)
    case .cameraSwitchTriggered:
        actionHandler.requestCameraSwitch(state: getState(), dispatch: dispatch)
    case .microphoneOffTriggered:
        actionHandler.requestMicrophoneMute(state: getState(), dispatch: dispatch)
    case .microphoneOnTriggered:
        actionHandler.requestMicrophoneUnmute(state: getState(), dispatch: dispatch)
    case .setCapabilities(let capabilities):
        actionHandler.setCapabilities(capabilities: capabilities, state: getState(), dispatch: dispatch)
    case .onCapabilitiesChanged(let event):
        actionHandler.onCapabilitiesChanged(event: event, state: getState(), dispatch: dispatch)
    case .raiseHandRequested:
        actionHandler.requestRaiseHand(state: getState(), dispatch: dispatch)
    case .sendReaction(let reaction):
        actionHandler.sendReaction(reaction, state: getState(), dispatch: dispatch)
    case .lowerHandRequested:
        actionHandler.requestLowerHand(state: getState(), dispatch: dispatch)
    case .backgroundEffectRequested(let effect):
        actionHandler.requestBackgroundEffect(effect: effect, state: getState(), dispatch: dispatch)
    case .audioDeviceChangeSucceeded:
        if (getState().localUserState.incomingAudioState.operation == .muted) {
            actionHandler.unMuteCall(state: getState(), dispatch: dispatch)
        }
    case .muteIncomingAudioRequested:
        actionHandler.muteCall(state: getState(), dispatch: dispatch)
    case .noiseSuppressionCallOn:
        actionHandler.noiseSuppressionCallOn(state: getState(), dispatch: dispatch)
    case .noiseSuppressionCallOff:
        actionHandler.noiseSuppressionCallOff(state: getState(), dispatch: dispatch)
    case .screenShareOnRequested:
        actionHandler.requestScreenSharingStream(state: getState(), dispatch: dispatch)
    case .screenShareOffRequested:
        actionHandler.requestStopScreenSharingStream(state: getState(), dispatch: dispatch)
    case .showChat(let azureCorrelationId):
        actionHandler.showChat(azureCorrelationId: azureCorrelationId)
        
    case .cameraOnSucceeded,
            .cameraOnFailed,
            .cameraOffSucceeded,
            .cameraOffFailed,
            .cameraPausedSucceeded,
            .cameraPausedFailed,
            .cameraSwitchSucceeded,
            .cameraSwitchFailed,
            .microphoneOnFailed,
            .microphoneOffFailed,
            .microphoneMuteStateUpdated,
            .microphonePreviewOn,
            .microphonePreviewOff,
            .noiseSuppressionPreviewOn,
            .noiseSuppressionPreviewOff,
            .audioDeviceChangeRequested,
            .audioDeviceChangeFailed,
            .changeDisplayNameRequested,
            .gridLayoutSelected,
            .speakerLayoutSelected,
            .raiseHandFailed,
            .lowerHandFailed,
            .raiseHandSucceeded,
            .lowerHandSucceeded,
            .backgroundEffectSetFailed,
            .screenShareOnTriggeredFailed,
            .screenShareOffTriggeredFailed,
            .resetLocalUserReaction,
            .screenShareOnSucceeded,
            .screenShareOffSucceeded,
            .participantRoleChanged:
        break
    }
}

private func handlePermissionAction(_ action: PermissionAction,
                                    _ actionHandler: CallingMiddlewareHandling,
                                    _ getState: () -> AppState,
                                    _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .cameraPermissionGranted:
        actionHandler.onCameraPermissionIsSet(state: getState(), dispatch: dispatch)
    case .audioPermissionGranted:
        actionHandler.onMicPermissionIsGranted(state: getState(), dispatch: dispatch)
    case .audioPermissionRequested,
            .audioPermissionDenied,
            .audioPermissionNotAsked,
            .cameraPermissionRequested,
            .cameraPermissionDenied,
            .cameraPermissionNotAsked:
        break
    }
}

private func handleLifecycleAction(_ action: LifecycleAction,
                                   _ actionHandler: CallingMiddlewareHandling,
                                   _ getState: () -> AppState,
                                   _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .backgroundEntered:
        actionHandler.enterBackground(state: getState(), dispatch: dispatch)
    case .foregroundEntered:
        actionHandler.enterForeground(state: getState(), dispatch: dispatch)
    case .willTerminate:
        if getState().callingState.status == .connected {
            actionHandler.endCall(state: getState(), dispatch: dispatch)
        }
    }
}

private func handleAudioSessionAction(_ action: AudioSessionAction,
                                      _ actionHandler: CallingMiddlewareHandling,
                                      _ getState: () -> AppState,
                                      _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .audioInterrupted:
        actionHandler.audioSessionInterrupted(state: getState(), dispatch: dispatch)
    case .audioInterruptEnded,
            .audioEngaged:
        break
    }
}

private func handleRemoteParticipantAction(_ action: RemoteParticipantsAction,
                                           _ actionHandler: CallingMiddlewareHandling,
                                           _ getState: () -> AppState,
                                           _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .admitAll:
        actionHandler.admitAllLobbyParticipants(state: getState(), dispatch: dispatch)
    case .declineAll:
        actionHandler.declineAllLobbyParticipants(state: getState(), dispatch: dispatch)
    case .admit(participantId: let participantId):
        actionHandler.admitLobbyParticipant(state: getState(), dispatch: dispatch, participantId: participantId)
    case .decline(participantId: let participantId):
        actionHandler.declineLobbyParticipant(state: getState(), dispatch: dispatch, participantId: participantId)
    case .remove(participantId: let participantId):
        actionHandler.removeParticipant(state: getState(), dispatch: dispatch, participantId: participantId)
    default:
        break
    }
}

private func handleCallDiagnisticAction(_ action: DiagnosticsAction,
                                        _ actionHandler: CallingMiddlewareHandling,
                                        _ getState: () -> AppState,
                                        _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .networkQuality(diagnostic: let diagnostic):
        actionHandler.onNetworkQualityCallDiagnosticsUpdated(
            state: getState(), dispatch: dispatch, diagnisticModel: diagnostic)
    case .network(diagnostic: let diagnostic):
        actionHandler.onNetworkCallDiagnosticsUpdated(
            state: getState(), dispatch: dispatch, diagnisticModel: diagnostic)
    case .media(diagnostic: let diagnostic):
        actionHandler.onMediaCallDiagnosticsUpdated(state: getState(), dispatch: dispatch, diagnisticModel: diagnostic)
    default:
        break
    }
}

private func handleToastNotificationAction(_ action: ToastNotificationAction,
                                           _ actionHandler: CallingMiddlewareHandling,
                                           _ getState: () -> AppState,
                                           _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .dismissNotification:
        actionHandler.dismissNotification(state: getState(), dispatch: dispatch)
    default:
        break
    }
}

private func handleCaptionsAction(_ action: CaptionsAction,
                                  _ actionHandler: CallingMiddlewareHandling,
                                  _ getState: () -> AppState,
                                  _ dispatch: @escaping ActionDispatch) {
    switch action {
    case .turnOnCaptions(language: let language):
        actionHandler.startCaptions(state: getState(), dispatch: dispatch, language: language)
    case .turnOffCaptions:
        actionHandler.stopCaptions(state: getState(), dispatch: dispatch)
    case .setSpokenLanguageRequested(language: let language):
        actionHandler.setCaptionsSpokenLanguage(state: getState(), dispatch: dispatch, language: language)
    case .setCaptionLanguageRequested(language: let language):
        actionHandler.setCaptionsLanguage(state: getState(), dispatch: dispatch, language: language)
    default:
        break
    }
}
