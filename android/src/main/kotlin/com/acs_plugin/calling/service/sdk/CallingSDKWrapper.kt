// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.service.sdk

/*  <CALL_START_TIME>
import kotlinx.coroutines.flow.SharedFlow
</CALL_START_TIME> */
/*  <CALL_START_TIME>
import java.util.Date
</CALL_START_TIME> */
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.media.projection.MediaProjectionManager
import android.util.DisplayMetrics
import android.util.Log
import androidx.core.content.ContextCompat
import com.acs_plugin.calling.CallCompositeException
import com.acs_plugin.calling.configuration.CallConfiguration
import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.models.*
import com.acs_plugin.calling.models.ParticipantCapabilityType
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import com.acs_plugin.calling.redux.state.*
import com.acs_plugin.calling.utilities.isAndroidTV
import com.acs_plugin.calling.utilities.toJavaUtil
import com.acs_plugin.utils.DisplaySize
import com.acs_plugin.utils.ScreenShareEventHandler
import com.acs_plugin.utils.ScreenShareEventHandlerImpl
import com.acs_plugin.utils.ScreenShareService
import com.azure.android.communication.calling.*
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.serialization.json.Json
import java.io.File
import java.util.*
import java.util.concurrent.CompletableFuture
import kotlin.math.abs
import kotlin.math.ceil
import com.azure.android.communication.calling.LocalVideoStream as NativeLocalVideoStream

internal class CallingSDKWrapper(
    private val context: Context,
    private val callingSDKEventHandler: CallingSDKEventHandler,
    private val callConfigInjected: CallConfiguration?,
    private val logger: Logger? = null,
    private val callingSDKInitializer: CallingSDKInitializer,
    private val compositeCaptionsOptions: CallCompositeCaptionsOptions? = null,
    private val localUserIdentifier: String?,
    // Add the screen share event handler
    private val screenShareEventHandler: ScreenShareEventHandler
    /* <END_CALL_FOR_ALL>
    private val isOnCallEndTerminateForAll: Boolean = false,
    </END_CALL_FOR_ALL> */
) : CallingSDK {
    private var nullableCall: Call? = null
    private var callClient: CallClient? = null
    private var activity: Activity? = null

    private var deviceManagerCompletableFuture: CompletableFuture<DeviceManager>? = null
    private var localVideoStreamCompletableFuture: CompletableFuture<LocalVideoStream>? = null
    private var endCallCompletableFuture: CompletableFuture<Void>? = null
    private var camerasInitializedCompletableFuture: CompletableFuture<Void>? = null
    private val setupCallCompletableFuture: CompletableFuture<Void> = CompletableFuture()

    private var videoDevicesUpdatedListener: VideoDevicesUpdatedListener? = null
    private var camerasCountStateFlow = MutableStateFlow(0)

    private var mediaProjectionManager: MediaProjectionManager? = null

    private val maxWidth = 1920.0
    private val maxHeight = 1080.0

    private val callConfig: CallConfiguration
        get() {
            try {
                return callConfigInjected!!
            } catch (ex: Exception) {
                throw CallCompositeException(
                    "Call configurations are not set",
                    IllegalStateException()
                )
            }
        }

    private val call: Call
        get() {
            try {
                return nullableCall!!
            } catch (ex: Exception) {
                throw CallCompositeException("Call is not started", IllegalStateException())
            }
        }

    /*  <CALL_START_TIME>
    override fun getCallStartTimeSharedFlow(): SharedFlow<Date> {
        return callingSDKEventHandler.getCallStartTimeSharedFlow()
    }
    </CALL_START_TIME> */

    override fun getRemoteParticipantsMap(): Map<String, RemoteParticipant> =
        callingSDKEventHandler.getRemoteParticipantsMap().mapValues { it.value.into() }

    override fun getCamerasCountStateFlow() = camerasCountStateFlow

    override fun getCallingStateWrapperSharedFlow() =
        callingSDKEventHandler.getCallingStateWrapperSharedFlow()

    override fun getCallIdStateFlow(): StateFlow<String?> = callingSDKEventHandler.getCallIdStateFlow()

    override fun getLocalParticipantRoleSharedFlow() =
        callingSDKEventHandler.getCallParticipantRoleSharedFlow()

    override fun getTotalRemoteParticipantCountSharedFlow() =
        callingSDKEventHandler.getTotalRemoteParticipantCountSharedFlow()

    override fun getCapabilitiesChangedEventSharedFlow() =
        callingSDKEventHandler.getCallCapabilitiesEventSharedFlow()

    override fun getIsMutedSharedFlow() = callingSDKEventHandler.getIsMutedSharedFlow()

    override fun getIsRecordingSharedFlow() = callingSDKEventHandler.getIsRecordingSharedFlow()

    override fun getIsTranscribingSharedFlow() =
        callingSDKEventHandler.getIsTranscribingSharedFlow()

    //region Call Diagnostics
    override fun getNetworkQualityCallDiagnosticSharedFlow() =
        callingSDKEventHandler.getNetworkQualityCallDiagnosticsSharedFlow()

    override fun getNetworkCallDiagnosticSharedFlow() =
        callingSDKEventHandler.getNetworkCallDiagnosticsSharedFlow()

    override fun getMediaCallDiagnosticSharedFlow() =
        callingSDKEventHandler.getMediaCallDiagnosticsSharedFlow()

    override fun getLogFiles(): List<File> {
        return callClient?.debugInfo?.supportFiles ?: Collections.emptyList()
    }

    override fun getRttSharedFlow() = callingSDKEventHandler.getRttTextSharedFlow()

    override fun sendRttMessage(message: String, isFinalized: Boolean) {
        val rttFeature = call.feature(Features.REAL_TIME_TEXT)
        rttFeature.send(message, isFinalized)
    }

    //endregion
    override fun getDominantSpeakersSharedFlow() =
        callingSDKEventHandler.getDominantSpeakersSharedFlow()

    override fun getRemoteParticipantInfoModelSharedFlow(): Flow<Map<String, ParticipantInfoModel>> =
        callingSDKEventHandler.getRemoteParticipantInfoModelFlow()

    override fun getRaisedHandParticipantsInfoSharedFlow(): SharedFlow<List<String>> =
        callingSDKEventHandler.getRaisedHandParticipantsInfoFlow()

    override fun getReactionParticipantsInfoSharedFlow(): SharedFlow<Map<String, ReactionPayload>> =
        callingSDKEventHandler.getReactionParticipantsInfoFlow()

    override fun hold(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val call = this.call
            call.hold().whenComplete { _, error ->
                if (error != null) {
                    completableFuture.completeExceptionally(error)
                } else {
                    completableFuture.complete(null)
                }
            }
        } catch (e: Exception) {
            // We can't access the call currently, return a no-op and exit
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun resume(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val call = this.call
            call.resume().whenComplete { _, error ->
                if (error != null) {
                    completableFuture.completeExceptionally(error)
                } else {
                    completableFuture.complete(null)
                }
            }
        } catch (e: Exception) {
            // We can't access the call currently, return a no-op and exit
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun endCall(): CompletableFuture<Void> {
        val call: Call?

        try {
            call = this.call
        } catch (e: Exception) {
            // We can't access the call currently, return a no-op and exit
            return CompletableFuture.runAsync { }
        }

        callingSDKEventHandler.onEndCall()
        val option = HangUpOptions()
        /* <END_CALL_FOR_ALL>
        if (isOnCallEndTerminateForAll) {
            option.isForEveryone = true
        }
        </END_CALL_FOR_ALL> */
        endCallCompletableFuture = call.hangUp(option).toJavaUtil()
        return endCallCompletableFuture!!
    }

    override fun admitAll(): CompletableFuture<CallCompositeLobbyErrorCode?> {
        val future = CompletableFuture<CallCompositeLobbyErrorCode?>()
        if (lobbyNullCheck(future)) return future
        nullableCall?.callLobby?.admitAll()?.whenComplete { _, error ->
            if (error != null) {
                var errorCode = CallCompositeLobbyErrorCode.UNKNOWN_ERROR
                if (error.cause is CallingCommunicationException) {
                    errorCode = getLobbyErrorCode(error.cause as CallingCommunicationException)
                }
                future.complete(errorCode)
            } else {
                future.complete(null)
            }
        }
        return future
    }

    override fun admit(userIdentifier: String): CompletableFuture<CallCompositeLobbyErrorCode?> {
        val future = CompletableFuture<CallCompositeLobbyErrorCode?>()
        if (lobbyNullCheck(future)) return future
        val participant = nullableCall?.remoteParticipants?.find { it.identifier.rawId.equals(userIdentifier) }
        participant?.let {
            nullableCall?.callLobby?.admit(listOf(it.identifier))?.whenComplete { _, error ->
                if (error != null) {
                    var errorCode = CallCompositeLobbyErrorCode.UNKNOWN_ERROR
                    if (error.cause is CallingCommunicationException) {
                        errorCode = getLobbyErrorCode(error.cause as CallingCommunicationException)
                    }
                    future.complete(errorCode)
                } else {
                    future.complete(null)
                }
            }
        }
        return future
    }

    private fun lobbyNullCheck(future: CompletableFuture<CallCompositeLobbyErrorCode?>): Boolean {
        if (nullableCall == null || nullableCall?.callLobby == null) {
            future.complete(CallCompositeLobbyErrorCode.UNKNOWN_ERROR)
            return true
        }
        return false
    }

    override fun reject(userIdentifier: String): CompletableFuture<CallCompositeLobbyErrorCode?> {
        val future = CompletableFuture<CallCompositeLobbyErrorCode?>()
        if (lobbyNullCheck(future)) return future
        val participant = nullableCall?.remoteParticipants?.find { it.identifier.rawId.equals(userIdentifier) }
        participant?.let {
            nullableCall?.callLobby?.reject(it.identifier)
                ?.whenComplete { _, error ->
                    if (error != null) {
                        var errorCode = CallCompositeLobbyErrorCode.UNKNOWN_ERROR
                        if (error.cause is CallingCommunicationException) {
                            errorCode = getLobbyErrorCode(error.cause as CallingCommunicationException)
                        }
                        future.complete(errorCode)
                    } else {
                        future.complete(null)
                    }
                }
        }
        return future
    }

    override fun removeParticipant(userIdentifier: String): CompletableFuture<Void> {
        val future = CompletableFuture<Void>()
        val participantToRemove = call.remoteParticipants
            .find {
                it.identifier.rawId == userIdentifier
            }

        participantToRemove?.let {
            call.removeParticipant(it).whenComplete { _, error ->
                if (error != null) {
                    future.completeExceptionally(error)
                } else {
                    future.complete(null)
                }
            }
        }

        return future
    }

    override fun dispose() {
        callingSDKEventHandler.dispose()
        cleanupResources()
    }

    override fun setupCall(): CompletableFuture<Void> {
        val setupCallClientFuture = callingSDKInitializer.setupCallClient()!!

        setupCallClientFuture
            .thenCompose {
                this.callClient = it
                CompletableFuture.allOf(createDeviceManager(), createCallAgent())
            }
            .whenComplete { _, error ->
                if (error != null) {
                    setupCallCompletableFuture.completeExceptionally(error)
                } else {
                    setupCallCompletableFuture.complete(null)
                }
            }

        return setupCallCompletableFuture
    }

    override fun getCapabilities(): Set<ParticipantCapabilityType> {
        val capabilitiesFeature = nullableCall?.feature { CapabilitiesCallFeature::class.java }
        capabilitiesFeature?.capabilities?.let { capabilities ->
            val filtered = capabilities
                .mapNotNull { it.into() }
                .filter { it.isAllowed }
                .map { it.type }

            return filtered.toSet()
        }

        return emptySet()
    }

    override fun startCall(
        cameraState: CameraState,
        audioState: AudioState,
    ): CompletableFuture<Void> {
        val startCallCompletableFuture = CompletableFuture<Void>()
        createCallAgent().thenAccept { agent: CallAgent ->
            val isNoiseSuppressionEnabled = audioState.noiseSuppression == NoiseSuppressionStatus.ON

            val audioOptions = OutgoingAudioOptions()
            audioOptions.isMuted = (audioState.operation != AudioOperationalStatus.ON)
            audioOptions.filters = OutgoingAudioFilters().apply {
                setNoiseSuppressionMode(if (isNoiseSuppressionEnabled) NoiseSuppressionMode.HIGH else NoiseSuppressionMode.OFF)
                setMusicModeEnabled(isNoiseSuppressionEnabled)
                setAcousticEchoCancellationEnabled(isNoiseSuppressionEnabled)
            }
            // it is possible to have camera state not on, (Example: waiting for local video stream)
            // if camera on is in progress, the waiting will make sure for starting call with right state
            if (camerasCountStateFlow.value != 0 && cameraState.operation != CameraOperationalStatus.OFF) {
                getLocalVideoStream().whenComplete { videoStream, error ->
                    val videoOptions = OutgoingVideoOptions()
                    if (error == null) {
                        val localVideoStreams =
                            arrayOf(videoStream.native as NativeLocalVideoStream)
                        videoOptions.setOutgoingVideoStreams(localVideoStreams.asList())
                    }
                    connectCall(agent, audioOptions, videoOptions)
                }.exceptionally { error ->
                    onJoinCallFailed(startCallCompletableFuture, error)
                }
            } else {
                connectCall(agent, audioOptions, null)
            }

            startCallCompletableFuture.complete(null)
        }
            .exceptionally { error ->
                onJoinCallFailed(startCallCompletableFuture, error)
            }

        return startCallCompletableFuture
    }

    override fun turnOnVideoAsync(): CompletableFuture<LocalVideoStream> {
        val result = CompletableFuture<LocalVideoStream>()
        this.getLocalVideoStream()
            .thenCompose { videoStream: LocalVideoStream ->
                call.startVideo(context, videoStream.native as NativeLocalVideoStream)
                    .toJavaUtil()
                    .whenComplete { _, error: Throwable? ->
                        if (error != null) {
                            result.completeExceptionally(error)
                        } else {
                            result.complete(videoStream)
                        }
                    }
            }
            .exceptionally { error ->
                result.completeExceptionally(error)
                null
            }

        return result
    }

    override fun turnOffVideoAsync(): CompletableFuture<Void> {
        val result = CompletableFuture<Void>()
        this.getLocalVideoStream()
            .thenAccept { videoStream: LocalVideoStream ->
                call.stopVideo(context, videoStream.native as NativeLocalVideoStream)
                    .whenComplete { _, error: Throwable? ->
                        if (error != null) {
                            result.completeExceptionally(error)
                        } else {
                            result.complete(null)
                        }
                    }
            }
            .exceptionally { error ->
                onJoinCallFailed(result, error)
            }
        return result
    }

    override fun switchCameraAsync(): CompletableFuture<CameraDeviceSelectionStatus> {
        return if (isAndroidTV(context)) {
            switchCameraAsyncAndroidTV()
        } else {
            switchCameraAsyncMobile()
        }
    }

    override fun turnOnMicAsync(): CompletableFuture<Void> {
        return call.unmute(context).toJavaUtil()
    }

    override fun turnOffMicAsync(): CompletableFuture<Void> {
        return call.mute(context).toJavaUtil()
    }

    override fun getLocalVideoStream(): CompletableFuture<LocalVideoStream> {
        val result = CompletableFuture<LocalVideoStream>()
        setupCallCompletableFuture.whenComplete { _, error ->
            if (error == null) {
                val localVideoStreamCompletableFuture = getLocalVideoStreamCompletableFuture()

                if (localVideoStreamCompletableFuture.isDone) {
                    result.complete(localVideoStreamCompletableFuture.get())
                } else if (!canCreateLocalVideoStream()) {
                    // cleanUpResources() could have been called before this, so we need to check if it's still
                    // alright to call initializeCameras()
                    result.complete(null)
                } else {
                    initializeCameras().whenComplete { _, error ->
                        if (error != null) {
                            localVideoStreamCompletableFuture.completeExceptionally(error)
                            result.completeExceptionally(error)
                        } else {
                            val desiredCamera = if (isAndroidTV(context)) {
                                getCameraByFacingTypeSelection()
                            } else {
                                getCamera(CameraFacing.FRONT)
                            }

                            localVideoStreamCompletableFuture.complete(
                                LocalVideoStreamWrapper(
                                    NativeLocalVideoStream(
                                        desiredCamera,
                                        context
                                    )
                                )
                            )
                            result.complete(localVideoStreamCompletableFuture.get())
                        }
                    }
                }
            }
        }

        return result
    }

    override fun setTelecomManagerAudioRoute(audioRoute: Int) {
        if (nullableCall != null) {
            call.setTelecomManagerAudioRoute(audioRoute)
        }
    }

    //region Captions
    override fun getCaptionsSupportedSpokenLanguagesSharedFlow() =
        callingSDKEventHandler.getCaptionsSupportedSpokenLanguagesSharedFlow()

    override fun getCaptionsSupportedCaptionLanguagesSharedFlow() =
        callingSDKEventHandler.getCaptionsSupportedCaptionLanguagesSharedFlow()

    override fun getIsCaptionsTranslationSupportedSharedFlow() =
        callingSDKEventHandler.getIsCaptionsTranslationSupportedSharedFlow()

    override fun getCaptionsReceivedSharedFlow() =
        callingSDKEventHandler.getCaptionsReceivedSharedFlow()

    override fun getActiveSpokenLanguageChangedSharedFlow() =
        callingSDKEventHandler.getActiveSpokenLanguageChangedSharedFlow()

    override fun getActiveCaptionLanguageChangedSharedFlow() =
        callingSDKEventHandler.getActiveCaptionLanguageChangedSharedFlow()

    override fun getCaptionsEnabledChangedSharedFlow() =
        callingSDKEventHandler.getCaptionsEnabledChangedSharedFlow()

    override fun getCaptionsTypeChangedSharedFlow() =
        callingSDKEventHandler.getCaptionsTypeChangedSharedFlow()

    /*  <CALL_START_TIME>
    override fun getCallStartTime(): Date? {
        if (nullableCall != null) {
            return call.startTime
        }
        return null
    }
    </CALL_START_TIME> */

    override fun startCaptions(spokenLanguage: String?): CompletableFuture<Void> {
        val resultFuture = CompletableFuture<Void>()
        val captionsFeature = call.feature(Features.CAPTIONS)
        captionsFeature.captions.whenComplete { callCaptions, throwable ->
            if (throwable != null) {
                resultFuture.completeExceptionally(throwable)
            } else {
                val captionsOptions = StartCaptionsOptions()
                if (!spokenLanguage.isNullOrEmpty()) {
                    captionsOptions.spokenLanguage = spokenLanguage
                } else if (this.compositeCaptionsOptions?.spokenLanguage?.isNotEmpty() == true) {
                    captionsOptions.spokenLanguage = this.compositeCaptionsOptions.spokenLanguage
                }
                callCaptions.startCaptions(captionsOptions)
                    .whenComplete { _, error: Throwable? ->
                        if (error != null) {
                            resultFuture.completeExceptionally(error)
                        } else {
                            callingSDKEventHandler.onCaptionsStart(callCaptions)
                            resultFuture.complete(null)
                        }
                    }
            }
        }
        return resultFuture
    }

    override fun stopCaptions(): CompletableFuture<Void> {
        val resultFuture = CompletableFuture<Void>()
        val captionsFeature = call.feature(Features.CAPTIONS)
        captionsFeature.captions.whenComplete { callCaptions, throwable ->
            if (throwable != null) {
                resultFuture.completeExceptionally(throwable)
            } else {
                callCaptions.stopCaptions()
                    .whenComplete { _, error: Throwable? ->
                        if (error != null) {
                            resultFuture.completeExceptionally(error)
                        } else {
                            callingSDKEventHandler.onCaptionsStop(callCaptions)
                            resultFuture.complete(null)
                        }
                    }
            }
        }
        return resultFuture
    }

    override fun setCaptionsSpokenLanguage(language: String): CompletableFuture<Void> {
        val resultFuture = CompletableFuture<Void>()
        val captionsFeature = call.feature(Features.CAPTIONS)
        captionsFeature.captions.whenComplete { callCaptions, throwable ->
            if (throwable != null) {
                resultFuture.completeExceptionally(throwable)
            } else {
                callCaptions.setSpokenLanguage(language)
                    .whenComplete { _, error: Throwable? ->
                        if (error != null) {
                            resultFuture.completeExceptionally(error)
                        } else {
                            resultFuture.complete(null)
                        }
                    }
            }
        }
        return resultFuture
    }

    override fun setCaptionsCaptionLanguage(language: String): CompletableFuture<Void> {
        val resultFuture = CompletableFuture<Void>()
        val captionsFeature = call.feature(Features.CAPTIONS)
        captionsFeature.captions.whenComplete { callCaptions, throwable ->
            if (throwable != null) {
                resultFuture.completeExceptionally(throwable)
            } else {
                if (callCaptions !is TeamsCaptions) {
                    resultFuture.complete(null)
                }
                (callCaptions as TeamsCaptions).setCaptionLanguage(language)
                    .whenComplete { _, error: Throwable? ->
                        if (error != null) {
                            resultFuture.completeExceptionally(error)
                        } else {
                            resultFuture.complete(null)
                        }
                    }
            }
        }
        return resultFuture
    }

    override fun turnOnBlur(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val nativeStream = localVideoStreamCompletableFuture?.get()?.native as? NativeLocalVideoStream
            val feature = nativeStream?.feature(Features.LOCAL_VIDEO_EFFECTS)
            feature?.enableEffect(BackgroundBlurEffect())
        } catch (e: Exception) {
            logger?.error("Error enabling blur effect", e)
        }

        return completableFuture
    }

    override fun turnOffBlur(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val nativeStream = localVideoStreamCompletableFuture?.get()?.native as? NativeLocalVideoStream
            val feature = nativeStream?.feature(Features.LOCAL_VIDEO_EFFECTS)
            feature?.disableEffect(BackgroundBlurEffect())
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
            logger?.error("Error disabling blur effect", e)
        }

        return completableFuture
    }

    override fun turnOnNoiseSuppression(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            call.liveOutgoingAudioFilters.apply {
                setNoiseSuppressionMode(NoiseSuppressionMode.HIGH)
                setMusicModeEnabled(true)
                setAcousticEchoCancellationEnabled(true)
            }
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun turnOffNoiseSuppression(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            call.liveOutgoingAudioFilters.apply {
                setNoiseSuppressionMode(NoiseSuppressionMode.OFF)
                setMusicModeEnabled(false)
                setAcousticEchoCancellationEnabled(false)
            }
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun muteAudio(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            call.muteIncomingAudio(context)
        } catch (e: Exception) {
            logger?.error("Failed to mute call", e)
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun unMuteAudio(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            call.unmuteIncomingAudio(context)
        } catch (e: Exception) {
            logger?.error("Failed to mute call", e)
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun raiseHand(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val raiseHandFeature: RaiseHandCallFeature = call.feature(Features.RAISED_HANDS)
            raiseHandFeature.raiseHand()
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun lowerHand(): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val raiseHandFeature: RaiseHandCallFeature = call.feature(Features.RAISED_HANDS)
            raiseHandFeature.lowerHand()
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun sendReaction(reactionType: ReactionType): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val options = DataChannelSenderOptions().apply {
                channelId = 1000
                bitrateInKbps = 32
                priority = DataChannelPriority.NORMAL
                reliability = DataChannelReliability.LOSSY
            }

            val feature = call.feature(Features.DATA_CHANNEL)
            val sender = feature.getDataChannelSender(options)

            val localUserId = localUserIdentifier ?: "unknown"
            val payload = ReactionPayload(reactionType)
            val message = ReactionMessage(mapOf(localUserId to payload))

            val json = Json.encodeToString(ReactionMessage.serializer(), message)
            sender.sendMessage(json.toByteArray(Charsets.UTF_8))

            completableFuture.complete(null)
        } catch (e: Exception) {
            logger?.error("Failed to send reaction via data channel", e)
            completableFuture.completeExceptionally(e)
        }
        return completableFuture
    }

    override fun turnOnShareScreen(activity: Activity): CompletableFuture<Void> {
        this.activity = activity
        val completableFuture = CompletableFuture<Void>()

        ScreenShareService.activeCall = call

        try {
            mediaProjectionManager =
                activity.getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
            val screenCaptureIntent = mediaProjectionManager!!.createScreenCaptureIntent()

            // Start the permission request
            activity.startActivityForResult(screenCaptureIntent, ScreenShareEventHandlerImpl.REQUEST_MEDIA_PROJECTION)

            // Wait for the result via our event handler
            if (screenShareEventHandler is ScreenShareEventHandlerImpl) {
                screenShareEventHandler.requestMediaProjectionPermission().thenAccept { (resultCode, data) ->
                    if (resultCode == Activity.RESULT_OK && data != null) {
                        try {
                            startScreenShareService(activity, resultCode, data)
                            completableFuture.complete(null)
                        } catch (e: Exception) {
                            completableFuture.completeExceptionally(e)
                        }
                    } else {
                        completableFuture.completeExceptionally(
                            IllegalStateException("MediaProjection permission denied")
                        )
                    }
                }.exceptionally { throwable ->
                    completableFuture.completeExceptionally(throwable)
                    null
                }
            } else {
                completableFuture.completeExceptionally(
                    IllegalStateException("Invalid screen share event handler")
                )
            }
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    override fun turnOffShareScreen(activity: Activity): CompletableFuture<Void> {
        val completableFuture = CompletableFuture<Void>()

        try {
            val serviceIntent = Intent(activity, ScreenShareService::class.java).apply {
                action = ScreenShareService.ACTION_STOP_SCREEN_SHARE
            }
            activity.stopService(serviceIntent)
            completableFuture.complete(null)
        } catch (e: Exception) {
            completableFuture.completeExceptionally(e)
        }

        return completableFuture
    }

    private fun startScreenShareService(context: Context, resultCode: Int, data: Intent) {
        val displaySize = getDisplaySize()
        val serviceIntent = Intent(context, ScreenShareService::class.java).apply {
            action = ScreenShareService.ACTION_START_SCREEN_SHARE
            putExtra(ScreenShareService.EXTRA_RESULT_CODE, resultCode)
            putExtra(ScreenShareService.EXTRA_RESULT_DATA, data)
            putExtra(ScreenShareService.EXTRA_WIDTH, displaySize.width)
            putExtra(ScreenShareService.EXTRA_HEIGHT, displaySize.height)
            putExtra(ScreenShareService.EXTRA_FRAME_RATE, 30)
        }
        ContextCompat.startForegroundService(context, serviceIntent)
    }

    // Method to be called from Activity's onActivityResult
    fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        screenShareEventHandler.onMediaProjectionResult(requestCode, resultCode, data)
    }

    private fun getDisplaySize(): DisplaySize {
        val displayMetrics = DisplayMetrics()
        activity?.windowManager?.defaultDisplay?.getMetrics(displayMetrics)
        var width = displayMetrics.widthPixels
        var height = displayMetrics.heightPixels

        if (height > maxHeight) {
            val percentage = abs((maxHeight / height) - 1)
            width = ceil((width * percentage)).toInt()
            height = maxHeight.toInt()
        }

        if (width > maxWidth) {
            val percentage = abs((maxWidth / width) - 1)
            height = ceil((height * percentage)).toInt()
            width = maxWidth.toInt()
        }

        return DisplaySize(width, height)
    }


    //endregion

    private fun createCallAgent(): CompletableFuture<CallAgent> {
        return callingSDKInitializer.createCallAgent()
    }

    private fun connectCall(
        agent: CallAgent,
        audioOptions: OutgoingAudioOptions,
        videoOptions: OutgoingVideoOptions?
    ) {
        if (callConfig.callType == CallType.ONE_TO_N_OUTGOING) {
            val startCallOptions = StartCallOptions()
            startCallOptions.outgoingAudioOptions = audioOptions
            videoOptions?.let { startCallOptions.outgoingVideoOptions = videoOptions }
            if (callConfig.participants == null || callConfig.participants?.isEmpty() == true) {
                throw CallCompositeException(
                    "Participants are not set",
                    IllegalStateException()
                )
            }
            nullableCall = agent.startCall(context, callConfig.participants, startCallOptions)
            callingSDKEventHandler.onCallCreated(call, callConfig.callType)
        } else if (callConfig.callType == CallType.ONE_TO_ONE_INCOMING) {
            val incomingCall = callingSDKInitializer.getIncomingCall()
            if (incomingCall == null || callConfig.incomingCallId != incomingCall.id) {
                throw CallCompositeException(
                    "Incoming call not found",
                    IllegalStateException()
                )
            }
            val acceptCallOptions = AcceptCallOptions()
            videoOptions.let { acceptCallOptions.outgoingVideoOptions = videoOptions }
            acceptCallOptions.outgoingAudioOptions = audioOptions
            nullableCall = incomingCall.accept(context, acceptCallOptions)?.get()
            callingSDKEventHandler.onCallCreated(call, callConfig.callType)
        } else {
            val joinCallOptions = JoinCallOptions()
            joinCallOptions.outgoingAudioOptions = audioOptions
            videoOptions?.let { joinCallOptions.outgoingVideoOptions = videoOptions }
            val callLocator: JoinMeetingLocator = when (callConfig.callType) {
                CallType.GROUP_CALL -> GroupCallLocator(callConfig.groupId)
                CallType.TEAMS_MEETING -> {
                    if (!callConfig.meetingLink.isNullOrEmpty()) {
                        TeamsMeetingLinkLocator(callConfig.meetingLink)
                    } else if (!callConfig.meetingId.isNullOrEmpty() && !callConfig.meetingPasscode.isNullOrEmpty()) {
                        TeamsMeetingIdLocator(callConfig.meetingId, callConfig.meetingPasscode)
                    } else {
                        throw CallCompositeException(
                            "Teams Meeting information is incomplete",
                            IllegalStateException()
                        )
                    }
                }

                CallType.ROOMS_CALL -> RoomCallLocator(callConfig.roomId)
                else -> {
                    throw CallCompositeException(
                        "Unsupported call type",
                        IllegalStateException()
                    )
                }
            }
            nullableCall = agent.join(context, callLocator, joinCallOptions)
            callingSDKEventHandler.onCallCreated(call, callConfig.callType)
        }
    }

    private fun getDeviceManagerCompletableFuture(): CompletableFuture<DeviceManager> {
        if (deviceManagerCompletableFuture == null ||
            deviceManagerCompletableFuture?.isCompletedExceptionally == true
        ) {
            deviceManagerCompletableFuture = CompletableFuture<DeviceManager>()
        }
        return deviceManagerCompletableFuture!!
    }

    private fun createDeviceManager(): CompletableFuture<DeviceManager> {
        val deviceManagerCompletableFuture = getDeviceManagerCompletableFuture()
        if (deviceManagerCompletableFuture.isCompletedExceptionally ||
            !deviceManagerCompletableFuture.isDone
        ) {
            callClient!!.getDeviceManager(context)
                .whenComplete { deviceManager: DeviceManager, getDeviceManagerError ->
                    if (getDeviceManagerError != null) {
                        deviceManagerCompletableFuture.completeExceptionally(
                            getDeviceManagerError
                        )
                    } else {
                        deviceManagerCompletableFuture.complete(deviceManager)
                    }
                }
        }

        return deviceManagerCompletableFuture
    }

    private fun initializeCameras(): CompletableFuture<Void> {
        if (camerasInitializedCompletableFuture == null) {
            camerasInitializedCompletableFuture = CompletableFuture<Void>()
            getDeviceManagerCompletableFuture().whenComplete { deviceManager, _ ->

                completeCamerasInitializedCompletableFuture()
                videoDevicesUpdatedListener =
                    VideoDevicesUpdatedListener {
                        completeCamerasInitializedCompletableFuture()
                    }
                deviceManager?.addOnCamerasUpdatedListener(videoDevicesUpdatedListener)
            }
        }

        return camerasInitializedCompletableFuture!!
    }

    private fun cameraExist() = getDeviceManagerCompletableFuture().get().cameras.isNotEmpty()

    private fun completeCamerasInitializedCompletableFuture() {
        camerasCountStateFlow.value =
            getDeviceManagerCompletableFuture().get().cameras.size
        if ((isAndroidTV(context) && cameraExist()) || doFrontAndBackCamerasExist()) {
            camerasInitializedCompletableFuture?.complete(null)
        }
    }

    // predefined order to return camera
    private fun getCameraByFacingTypeSelection(): com.azure.android.communication.calling.VideoDeviceInfo? {
        listOf(
            CameraFacing.FRONT,
            CameraFacing.BACK,
            CameraFacing.EXTERNAL,
            CameraFacing.PANORAMIC,
            CameraFacing.LEFT_FRONT,
            CameraFacing.RIGHT_FRONT,
            CameraFacing.UNKNOWN
        ).forEach {
            val camera = getCamera(it)
            if (camera != null) {
                return camera
            }
        }
        return null
    }

    private fun doFrontAndBackCamerasExist(): Boolean {
        return getCamera(CameraFacing.FRONT) != null &&
                getCamera(CameraFacing.BACK) != null
    }

    private fun getCamera(
        cameraFacing: CameraFacing,
    ) = getDeviceManagerCompletableFuture().get().cameras?.find {
        it.cameraFacing.name.equals(
            cameraFacing.name,
            ignoreCase = true
        )
    }

    private fun getNextCamera(deviceId: String): com.azure.android.communication.calling.VideoDeviceInfo? {
        val cameras = getDeviceManagerCompletableFuture().get().cameras
        val deviceIndex = cameras?.indexOfFirst { it.id == deviceId }
        deviceIndex?.let {
            val nextCameraIndex = (deviceIndex + 1) % cameras.size
            return cameras[nextCameraIndex]
        }
        return null
    }

    private fun getLocalVideoStreamCompletableFuture(): CompletableFuture<LocalVideoStream> {
        if (localVideoStreamCompletableFuture == null || localVideoStreamCompletableFuture?.isCompletedExceptionally == true ||
            localVideoStreamCompletableFuture?.isCancelled == true
        ) {
            localVideoStreamCompletableFuture = CompletableFuture<LocalVideoStream>()
        }
        return localVideoStreamCompletableFuture!!
    }

    private fun cleanupResources() {
        videoDevicesUpdatedListener?.let {
            deviceManagerCompletableFuture?.get()?.removeOnCamerasUpdatedListener(it)
        }
        callClient = null
        nullableCall = null
        localVideoStreamCompletableFuture = null
        camerasInitializedCompletableFuture = null
        deviceManagerCompletableFuture = null
        endCallCompletableFuture?.complete(null)
    }

    private fun canCreateLocalVideoStream() =
        deviceManagerCompletableFuture != null || callClient != null

    private fun switchCameraAsyncAndroidTV(): CompletableFuture<CameraDeviceSelectionStatus> {
        val result = CompletableFuture<CameraDeviceSelectionStatus>()
        this.getLocalVideoStream()
            .thenAccept { videoStream: LocalVideoStream ->
                initializeCameras().thenAccept {
                    val desiredCamera = getNextCamera(videoStream.source.id)
                    if (desiredCamera == null) {
                        result.completeExceptionally(null)
                    } else {
                        videoStream.switchSource(desiredCamera.into())
                            .exceptionally {
                                result.completeExceptionally(it)
                                null
                            }.thenRun {
                                val cameraDeviceSelectionStatus =
                                    when (desiredCamera.cameraFacing) {
                                        CameraFacing.FRONT -> CameraDeviceSelectionStatus.FRONT
                                        CameraFacing.BACK -> CameraDeviceSelectionStatus.BACK
                                        CameraFacing.UNKNOWN -> CameraDeviceSelectionStatus.UNKNOWN
                                        CameraFacing.RIGHT_FRONT -> CameraDeviceSelectionStatus.RIGHT_FRONT
                                        CameraFacing.LEFT_FRONT -> CameraDeviceSelectionStatus.LEFT_FRONT
                                        CameraFacing.PANORAMIC -> CameraDeviceSelectionStatus.PANORAMIC
                                        CameraFacing.EXTERNAL -> CameraDeviceSelectionStatus.EXTERNAL
                                        else -> null
                                    }

                                when (cameraDeviceSelectionStatus) {
                                    null -> result.completeExceptionally(
                                        Throwable(
                                            "Not supported camera facing type"
                                        )
                                    )

                                    else -> result.complete(cameraDeviceSelectionStatus)
                                }
                            }
                    }
                }
            }
            .exceptionally { error ->
                result.completeExceptionally(error)
                null
            }

        return result
    }

    private fun switchCameraAsyncMobile(): CompletableFuture<CameraDeviceSelectionStatus> {
        val result = CompletableFuture<CameraDeviceSelectionStatus>()
        this.getLocalVideoStream()
            .thenAccept { videoStream: LocalVideoStream ->
                val desiredCameraState = when (videoStream.source.cameraFacing) {
                    CameraFacing.FRONT -> CameraFacing.BACK
                    else -> CameraFacing.FRONT
                }

                initializeCameras().thenAccept {

                    val desiredCamera =
                        getCamera(
                            desiredCameraState,
                        )

                    if (desiredCamera == null) {
                        result.completeExceptionally(null)
                    } else {
                        videoStream.switchSource(desiredCamera.into())
                            .exceptionally {
                                result.completeExceptionally(it)
                                null
                            }.thenRun {
                                val cameraDeviceSelectionStatus =
                                    when (desiredCamera.cameraFacing) {
                                        CameraFacing.FRONT -> CameraDeviceSelectionStatus.FRONT
                                        CameraFacing.BACK -> CameraDeviceSelectionStatus.BACK
                                        else -> null
                                    }

                                when (cameraDeviceSelectionStatus) {
                                    null -> result.completeExceptionally(
                                        Throwable(
                                            "Not supported camera facing type"
                                        )
                                    )

                                    else -> result.complete(cameraDeviceSelectionStatus)
                                }
                            }
                    }
                }
            }
            .exceptionally { error ->
                result.completeExceptionally(error)
                null
            }

        return result
    }

    private fun onJoinCallFailed(
        startCallCompletableFuture: CompletableFuture<Void>,
        error: Throwable?,
    ): Nothing? {
        startCallCompletableFuture.completeExceptionally(error)
        return null
    }
}
