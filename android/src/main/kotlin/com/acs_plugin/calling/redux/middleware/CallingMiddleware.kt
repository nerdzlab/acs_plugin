// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.middleware

import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.redux.Dispatch
import com.acs_plugin.calling.redux.Middleware
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.AudioSessionAction
import com.acs_plugin.calling.redux.action.CallDiagnosticsAction
import com.acs_plugin.calling.redux.action.CallingAction
import com.acs_plugin.calling.redux.action.CaptionsAction
import com.acs_plugin.calling.redux.action.ErrorAction
import com.acs_plugin.calling.redux.action.LifecycleAction
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.action.ParticipantAction
import com.acs_plugin.calling.redux.action.PermissionAction
import com.acs_plugin.calling.redux.action.RttAction
import com.acs_plugin.calling.redux.action.ToastNotificationAction
import com.acs_plugin.calling.redux.middleware.handler.CallingMiddlewareActionHandler
import com.acs_plugin.calling.redux.state.ReduxState

internal interface CallingMiddleware

internal class CallingMiddlewareImpl(
    private val callingMiddlewareActionHandler: CallingMiddlewareActionHandler,
    private val logger: Logger,
) :
    Middleware<ReduxState>,
    CallingMiddleware {

    override fun invoke(store: Store<ReduxState>) = { next: Dispatch ->
        { action: Action ->
            logger.info(action.toString())
            when (action) {
                is LifecycleAction.EnterBackgroundTriggered -> {
                    callingMiddlewareActionHandler.enterBackground(store)
                }
                is LifecycleAction.EnterForegroundTriggered -> {
                    callingMiddlewareActionHandler.enterForeground(store)
                }
                is LocalParticipantAction.CameraPreviewOnRequested -> {
                    callingMiddlewareActionHandler.requestCameraPreviewOn(store)
                }
                is LocalParticipantAction.CameraPreviewOnTriggered -> {
                    callingMiddlewareActionHandler.turnCameraPreviewOn(store)
                }
                is LocalParticipantAction.CameraOffTriggered -> {
                    callingMiddlewareActionHandler.turnCameraOff(store)
                }
                is LocalParticipantAction.CameraOnRequested -> {
                    callingMiddlewareActionHandler.requestCameraOn(store)
                }
                is LocalParticipantAction.CameraOnTriggered -> {
                    callingMiddlewareActionHandler.turnCameraOn(store)
                }
                is LocalParticipantAction.CameraSwitchTriggered -> {
                    callingMiddlewareActionHandler.switchCamera(store)
                }
                is LocalParticipantAction.MicOffTriggered -> {
                    callingMiddlewareActionHandler.turnMicOff(store)
                }
                is AudioSessionAction.AudioFocusApproved -> {
                    store.dispatch(CallingAction.ResumeRequested())
                }
                is AudioSessionAction.AudioFocusInterrupted -> {
                    store.dispatch(CallingAction.HoldRequested())
                }
                is LocalParticipantAction.MicOnTriggered -> {
                    callingMiddlewareActionHandler.turnMicOn(store)
                }
                is LocalParticipantAction.AudioStateOperationUpdated -> {
                    callingMiddlewareActionHandler.onUpdateAudioStateOperation(action.audioOperationalStatus, store)
                }
                is LocalParticipantAction.BlurPreviewOnTriggered -> {
                    callingMiddlewareActionHandler.turnBlurOn(store)
                }
                is LocalParticipantAction.BlurPreviewOffTriggered -> {
                    callingMiddlewareActionHandler.turnBlurOff(store)
                }
                is LocalParticipantAction.NoiseSuppressionOnTriggered -> {
                    callingMiddlewareActionHandler.turnNoiseSuppressionOn(store)
                }
                is LocalParticipantAction.NoiseSuppressionOffTriggered -> {
                    callingMiddlewareActionHandler.turnNoiseSuppressionOff(store)
                }
                is LocalParticipantAction.RaiseHandTriggered -> {
                    callingMiddlewareActionHandler.raiseHand(store)
                }
                is LocalParticipantAction.LowerHandTriggered -> {
                    callingMiddlewareActionHandler.lowerHand(store)
                }
                is LocalParticipantAction.SendReactionTriggered -> {
                    callingMiddlewareActionHandler.sendReaction(action.reactionType, store)
                }
                is LocalParticipantAction.ShareScreenTriggered -> {
                    callingMiddlewareActionHandler.turnShareScreenOn(store)
                }
                is LocalParticipantAction.StopShareScreenTriggered -> {
                    callingMiddlewareActionHandler.turnShareScreenOff(store)
                }
                is CallingAction.HoldRequested -> {
                    callingMiddlewareActionHandler.hold(store)
                }
                is CallingAction.ResumeRequested -> {
                    callingMiddlewareActionHandler.resume(store)
                }
                is CallingAction.CallEndRequested -> {
                    callingMiddlewareActionHandler.endCall(store)
                }
                is CallingAction.SetupCall -> {
                    callingMiddlewareActionHandler.setupCall(store)
                }
                is CallingAction.CallStartRequested -> {
                    callingMiddlewareActionHandler.startCall(store)
                }
                is CallingAction.CallRequestedWithoutSetup -> {
                    callingMiddlewareActionHandler.callSetupWithSkipSetupScreen(store)
                }
                is PermissionAction.CameraPermissionIsSet -> {
                    callingMiddlewareActionHandler.onCameraPermissionIsSet(store)
                }
                is ErrorAction.EmergencyExit -> {
                    callingMiddlewareActionHandler.exit(store)
                }
                is ParticipantAction.AdmitAll -> {
                    callingMiddlewareActionHandler.admitAll(store)
                }
                is ParticipantAction.Admit -> {
                    callingMiddlewareActionHandler.admit(action.userIdentifier, store)
                }
                is ParticipantAction.Reject -> {
                    callingMiddlewareActionHandler.reject(action.userIdentifier, store)
                }
                is ParticipantAction.Remove -> {
                    callingMiddlewareActionHandler.removeParticipant(action.userIdentifier, store)
                }
                is LocalParticipantAction.SetCapabilities -> {
                    callingMiddlewareActionHandler.setCapabilities(action.capabilities, store)
                }
                is CallDiagnosticsAction.NetworkQualityCallDiagnosticsUpdated -> {
                    callingMiddlewareActionHandler
                        .onNetworkQualityCallDiagnosticsUpdated(action.networkQualityCallDiagnosticModel, store)
                }
                is CallDiagnosticsAction.NetworkCallDiagnosticsUpdated -> {
                    callingMiddlewareActionHandler
                        .onNetworkCallDiagnosticsUpdated(action.networkCallDiagnosticModel, store)
                }
                is CallDiagnosticsAction.MediaCallDiagnosticsUpdated -> {
                    callingMiddlewareActionHandler
                        .onMediaCallDiagnosticsUpdated(action.mediaCallDiagnosticModel, store)
                }
                is ToastNotificationAction.DismissNotification -> {
                    callingMiddlewareActionHandler.dismissNotification(store)
                }
                is LocalParticipantAction.AudioDeviceChangeRequested -> {
                    callingMiddlewareActionHandler.onAudioDeviceChangeRequested(action.requestedAudioDevice, store)
                }
                is LocalParticipantAction.AudioDeviceChangeSucceeded -> {
                    callingMiddlewareActionHandler.onAudioDeviceChangeSucceeded(action.selectedAudioDevice, store)
                }
                is AudioSessionAction.AudioFocusRequesting -> {
                    callingMiddlewareActionHandler.onAudioFocusRequesting(store)
                }
                is CaptionsAction.StartRequested -> {
                    callingMiddlewareActionHandler.startCaptions(action.language, store)
                }
                is CaptionsAction.StopRequested -> {
                    callingMiddlewareActionHandler.stopCaptions(store)
                }
                is CaptionsAction.SetSpokenLanguageRequested -> {
                    callingMiddlewareActionHandler.setCaptionsSpokenLanguage(action.language, store)
                }
                is CaptionsAction.SetCaptionLanguageRequested -> {
                    callingMiddlewareActionHandler.setCaptionsCaptionLanguage(action.language, store)
                }
                is RttAction.SendRtt -> {
                    callingMiddlewareActionHandler.sendRttMessage(action.message, action.isFinalized, store)
                }
            }
            next(action)
        }
    }
}
