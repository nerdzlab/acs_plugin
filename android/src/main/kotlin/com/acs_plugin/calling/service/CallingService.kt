// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.service

import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.models.CallCompositeCaptionsData
import com.acs_plugin.calling.models.CallCompositeCaptionsType
import com.acs_plugin.calling.models.CallCompositeLobbyErrorCode
import com.acs_plugin.calling.models.CallInfoModel
import com.acs_plugin.calling.models.CapabilitiesChangedEvent
import com.acs_plugin.calling.models.MediaCallDiagnosticModel
import com.acs_plugin.calling.models.NetworkCallDiagnosticModel
import com.acs_plugin.calling.models.NetworkQualityCallDiagnosticModel
import com.acs_plugin.calling.models.ParticipantCapabilityType
import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.models.ParticipantRole
import com.acs_plugin.calling.models.ReactionPayload
import com.acs_plugin.calling.models.RttMessage
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import com.acs_plugin.calling.redux.state.AudioState
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.CameraDeviceSelectionStatus
import com.acs_plugin.calling.redux.state.CameraState
import com.acs_plugin.calling.service.sdk.CallingSDK
import com.acs_plugin.calling.utilities.CoroutineContextProvider
import java.util.concurrent.CompletableFuture
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.launch
import java.io.File
/*  <CALL_START_TIME>
import java.util.Date
</CALL_START_TIME> */

internal class CallingService(
    private val callingSdk: CallingSDK,
    coroutineContextProvider: CoroutineContextProvider,
    private val logger: Logger? = null,
) {
    companion object {
        private const val LOCAL_VIDEO_STREAM_ID = "BuiltInCameraVideoStream"
    }

    private val participantsInfoModelSharedFlow =
        MutableSharedFlow<Map<String, ParticipantInfoModel>>()
    private val dominantSpeakersSharedFlow = MutableSharedFlow<List<String>>()
    private val raisedHandParticipantsInfoSharedFlow = MutableSharedFlow<List<String>>()
    private val reactionParticipantsInfoSharedFlow = MutableSharedFlow<Map<String, ReactionPayload>>()
    private var callInfoModelSharedFlow = MutableSharedFlow<CallInfoModel>()

    private val coroutineScope = CoroutineScope((coroutineContextProvider.Default))
    private var callingStatus: CallingStatus = CallingStatus.NONE

    fun turnCameraOn(): CompletableFuture<String> {
        return callingSdk.turnOnVideoAsync().thenApply { stream ->
            stream?.source?.id
        }
    }

    fun turnCameraOff(): CompletableFuture<Void> {
        return callingSdk.turnOffVideoAsync()
    }

    fun switchCamera(): CompletableFuture<CameraDeviceSelectionStatus> {
        return callingSdk.switchCameraAsync()
    }

    fun admitAll(): CompletableFuture<CallCompositeLobbyErrorCode?> {
        return callingSdk.admitAll()
    }

    fun admit(userIdentifier: String): CompletableFuture<CallCompositeLobbyErrorCode?> {
        return callingSdk.admit(userIdentifier)
    }

    fun reject(userIdentifier: String): CompletableFuture<CallCompositeLobbyErrorCode?> {
        return callingSdk.reject(userIdentifier)
    }

    fun removeParticipant(userIdentifier: String): CompletableFuture<Void> {
        return callingSdk.removeParticipant(userIdentifier)
    }

    fun turnMicOff(): CompletableFuture<Void> {
        return callingSdk.turnOffMicAsync()
    }

    fun turnMicOn(): CompletableFuture<Void> {
        return callingSdk.turnOnMicAsync()
    }

    fun turnLocalCameraOn(): CompletableFuture<String> {
        return callingSdk.getLocalVideoStream().thenApply {
            /**
             * On switch camera video stream ID is changed
             * We do not sync local video stream ID to store on camera switch
             * Team decided to use single ID for local video stream
             */
            LOCAL_VIDEO_STREAM_ID
        }
    }

    /*  <CALL_START_TIME>
    fun getCallStartTime(): Date? = callingSdk.getCallStartTime()
    fun getCallStartTimeSharedFlow(): SharedFlow<Date> = callingSdk.getCallStartTimeSharedFlow()
    </CALL_START_TIME> */

    fun getParticipantsInfoModelSharedFlow(): SharedFlow<Map<String, ParticipantInfoModel>> {
        return participantsInfoModelSharedFlow
    }

    fun getLocalParticipantRoleSharedFlow(): SharedFlow<ParticipantRole?> {
        return callingSdk.getLocalParticipantRoleSharedFlow()
    }

    fun getTotalRemoteParticipantCountSharedFlow() = callingSdk.getTotalRemoteParticipantCountSharedFlow()

    fun getCapabilitiesChangedEventSharedFlow(): SharedFlow<CapabilitiesChangedEvent> =
        callingSdk.getCapabilitiesChangedEventSharedFlow()

    fun getDominantSpeakersSharedFlow(): SharedFlow<List<String>> {
        return dominantSpeakersSharedFlow
    }

    fun getRaisedHandParticipantsInfoSharedFlow(): SharedFlow<List<String>> {
        return raisedHandParticipantsInfoSharedFlow
    }

    fun getReactionParticipantsInfoSharedFlow(): SharedFlow<Map<String, ReactionPayload>> {
        return reactionParticipantsInfoSharedFlow
    }

    fun getIsMutedSharedFlow(): Flow<Boolean> = callingSdk.getIsMutedSharedFlow()

    fun getIsRecordingSharedFlow(): Flow<Boolean> = callingSdk.getIsRecordingSharedFlow()

    fun getCallInfoModelEventSharedFlow(): SharedFlow<CallInfoModel> = callInfoModelSharedFlow

    fun getCallIdStateFlow(): SharedFlow<String?> = callingSdk.getCallIdStateFlow()

    fun getIsTranscribingSharedFlow(): Flow<Boolean> = callingSdk.getIsTranscribingSharedFlow()

    //region Call Diagnostics
    fun getNetworkQualityCallDiagnosticsFlow(): Flow<NetworkQualityCallDiagnosticModel> = callingSdk.getNetworkQualityCallDiagnosticSharedFlow()

    fun getNetworkCallDiagnosticsFlow(): Flow<NetworkCallDiagnosticModel> = callingSdk.getNetworkCallDiagnosticSharedFlow()

    fun getMediaCallDiagnosticsFlow(): Flow<MediaCallDiagnosticModel> = callingSdk.getMediaCallDiagnosticSharedFlow()
    //endregion

    fun getCamerasCountStateFlow() = callingSdk.getCamerasCountStateFlow()

    fun getRttFlow(): Flow<RttMessage> = callingSdk.getRttSharedFlow()

    fun endCall() = callingSdk.endCall()

    fun hold() = callingSdk.hold()

    fun resume() = callingSdk.resume()

    fun setupCall() = callingSdk.setupCall()

    fun dispose() {
        coroutineScope.cancel()
        callingSdk.dispose()
    }

    fun startCall(cameraState: CameraState, audioState: AudioState): CompletableFuture<Void> {
        coroutineScope.launch {
            callingSdk.getCallingStateWrapperSharedFlow().collect {
                logger?.debug(it.toString())
                val callStateError = it.asCallStateError(currentStatus = callingStatus)
                callingStatus = it.toCallStatus()
                if (callingStatus == CallingStatus.DISCONNECTED) {
                    callInfoModelSharedFlow.emit(CallInfoModel(callingStatus, callStateError, it.callEndReason, it.callEndReasonSubCode))
                } else {
                    callInfoModelSharedFlow.emit(CallInfoModel(callingStatus, callStateError))
                }
            }
        }

        coroutineScope.launch {
            callingSdk.getRemoteParticipantInfoModelSharedFlow().collect {
                participantsInfoModelSharedFlow.emit(it)
            }
        }

        coroutineScope.launch {
            callingSdk.getDominantSpeakersSharedFlow().collect {
                dominantSpeakersSharedFlow.emit(it.speakers)
            }
        }

        coroutineScope.launch {
            callingSdk.getRaisedHandParticipantsInfoSharedFlow().collect {
                raisedHandParticipantsInfoSharedFlow.emit(it)
            }
        }

        coroutineScope.launch {
            callingSdk.getReactionParticipantsInfoSharedFlow().collect {
                reactionParticipantsInfoSharedFlow.emit(it)
            }
        }

        return callingSdk.startCall(cameraState, audioState)
    }

    fun sendRttMessage(message: String, isFinalized: Boolean) {
        callingSdk.sendRttMessage(message, isFinalized)
    }

    fun getLogFiles(): List<File> = callingSdk.getLogFiles()

    fun setTelecomManagerAudioRoute(audioRoute: Int) {
        callingSdk.setTelecomManagerAudioRoute(audioRoute)
    }

    fun getCallCapabilities(): Set<ParticipantCapabilityType> = callingSdk.getCapabilities()

    //region Captions
    fun startCaptions(spokenLanguage: String?) = callingSdk.startCaptions(spokenLanguage)

    fun stopCaptions(): CompletableFuture<Void> {
        return callingSdk.stopCaptions()
    }

    fun setCaptionsSpokenLanguage(language: String): CompletableFuture<Void> {
        return callingSdk.setCaptionsSpokenLanguage(language)
    }

    fun setCaptionsCaptionLanguage(language: String): CompletableFuture<Void> {
        return callingSdk.setCaptionsCaptionLanguage(language)
    }

    fun turnBlurOn(): CompletableFuture<Void> {
        return callingSdk.turnOnBlur()
    }

    fun turnBlurOff(): CompletableFuture<Void> {
        return callingSdk.turnOffBlur()
    }

    fun turnOnNoiseSuppression(): CompletableFuture<Void> {
        return callingSdk.turnOnNoiseSuppression()
    }

    fun turnOffNoiseSuppression(): CompletableFuture<Void> {
        return callingSdk.turnOffNoiseSuppression()
    }

    fun raiseHand(): CompletableFuture<Void> {
        return callingSdk.raiseHand()
    }

    fun lowerHand(): CompletableFuture<Void> {
        return callingSdk.lowerHand()
    }

    fun sendReaction(reactionType: ReactionType): CompletableFuture<Void> {
        return callingSdk.sendReaction(reactionType)
    }

    fun turnOnShareScreen(): CompletableFuture<Void> {
        return callingSdk.turnOnShareScreen()
    }

    fun turnOffShareScreen(): CompletableFuture<Void> {
        return callingSdk.turnOffShareScreen()
    }

    fun getCaptionsSupportedSpokenLanguagesSharedFlow(): SharedFlow<List<String>> {
        return callingSdk.getCaptionsSupportedSpokenLanguagesSharedFlow()
    }

    fun getCaptionsSupportedCaptionLanguagesSharedFlow(): SharedFlow<List<String>> {
        return callingSdk.getCaptionsSupportedCaptionLanguagesSharedFlow()
    }

    fun getIsCaptionsTranslationSupportedSharedFlow(): SharedFlow<Boolean> {
        return callingSdk.getIsCaptionsTranslationSupportedSharedFlow()
    }

    fun getCaptionsReceivedSharedFlow(): SharedFlow<CallCompositeCaptionsData> {
        return callingSdk.getCaptionsReceivedSharedFlow()
    }

    fun getActiveSpokenLanguageChangedSharedFlow(): SharedFlow<String> {
        return callingSdk.getActiveSpokenLanguageChangedSharedFlow()
    }

    fun getActiveCaptionLanguageChangedSharedFlow(): SharedFlow<String> {
        return callingSdk.getActiveCaptionLanguageChangedSharedFlow()
    }

    fun getCaptionsEnabledChangedSharedFlow(): SharedFlow<Boolean> {
        return callingSdk.getCaptionsEnabledChangedSharedFlow()
    }

    fun getCaptionsTypeChangedSharedFlow(): SharedFlow<CallCompositeCaptionsType> {
        return callingSdk.getCaptionsTypeChangedSharedFlow()
    }
    //endregion
}
