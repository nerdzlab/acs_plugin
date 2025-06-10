package com.acs_plugin.utils

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import com.acs_plugin.IncomingCallActivity
import com.acs_plugin.R
import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.CallCompositeBuilder
import com.acs_plugin.calling.models.*
import com.azure.android.communication.common.CommunicationIdentifier
import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.communication.common.CommunicationTokenRefreshOptions
import com.google.firebase.messaging.FirebaseMessaging
import kotlinx.coroutines.flow.MutableStateFlow
import java.util.*

class CallCompositeManager(private val context: Context) {
    val callCompositeCallStateStateFlow = MutableStateFlow("")
    private var callComposite: CallComposite? = null
    private var incomingCallId: String? = null
    private var callScreenHeaderOptions: CallCompositeCallScreenHeaderViewData? = null
    private var remoteParticipantsCount = 0

//    init {
//        try {
//            AndroidThreeTen.init(context.applicationContext)
//        } catch (e: java.lang.IllegalStateException) {
//            // AndroidThreeTen is already initialized
//            // Ignore this exception
//            Log.d("CallCompositeManager", "AndroidThreeTen already initialized", e)
//        }
//    }

    fun launch(
        applicationContext: Context,
        identity: String,
        acsToken: String,
        displayName: String,
        groupId: UUID?,
        roomId: String?,
        meetingId: String?,
        participantMris: String?,
    ) {


        createCallCompositeAndSubscribeToEvents(
            applicationContext,
            acsToken,
            displayName,
            identity,
        )

        val localOptions = getLocalOptions(applicationContext)

        val participants = participantMris?.split(",")
        if (!participants.isNullOrEmpty()) {
            if (localOptions == null) {
                callComposite?.launch(applicationContext, participants.map { CommunicationIdentifier.fromRawId(it) })
            } else {
                callComposite?.launch(
                    applicationContext,
                    participants.map { CommunicationIdentifier.fromRawId(it) },
                    localOptions
                )
            }
        } else {
            val useDeprecatedLaunch = false
            val remoteOptions = getRemoteOptions(
                acsToken,
                groupId,
                roomId,
                displayName,
            )
            val locator = getLocator(
                groupId,
                roomId,
            )

            if (localOptions == null) {
                if (useDeprecatedLaunch) {
                    callComposite?.launch(applicationContext, remoteOptions)
                } else {
                    callComposite?.launch(applicationContext, locator)
                }
            } else {
                if (useDeprecatedLaunch) {
                    callComposite?.launch(applicationContext, remoteOptions, localOptions)
                } else {
                    callComposite?.launch(applicationContext, locator, localOptions)
                }
            }
        }
    }

    private fun getRemoteOptions(
        acsToken: String,
        groupId: UUID?,
        roomId: String?,
        displayName: String,
    ): CallCompositeRemoteOptions {
        val communicationTokenRefreshOptions =
            CommunicationTokenRefreshOptions({ acsToken }, true)
        val communicationTokenCredential =
            CommunicationTokenCredential(communicationTokenRefreshOptions)

        val locator: CallCompositeJoinLocator =
            when {
                groupId != null -> CallCompositeGroupCallLocator(groupId)
                roomId != null -> CallCompositeRoomLocator(roomId)
                else -> throw IllegalArgumentException("Cannot launch call composite with provided arguments.")
            }

        return CallCompositeRemoteOptions(locator, communicationTokenCredential, displayName)
    }

    private fun getLocator(
        groupId: UUID?,
        roomId: String?,
    ): CallCompositeJoinLocator {
        val locator: CallCompositeJoinLocator =
            when {
                groupId != null -> CallCompositeGroupCallLocator(groupId)
                roomId != null -> CallCompositeRoomLocator(roomId)
                else -> throw IllegalArgumentException("Cannot launch call composite with provided arguments.")
            }

        return locator
    }

    private fun getLocalOptions(context: Context): CallCompositeLocalOptions? {
        val localOptions = CallCompositeLocalOptions()
        var isAnythingChanged = false

        val renderedDisplayName = true
        var avatarImageBitmap: Bitmap? = null


        if (true) {
            val participantViewData = CallCompositeParticipantViewData()
            if (renderedDisplayName != null)
                participantViewData.setDisplayName("renderedDisplayName")
            if (avatarImageBitmap != null)
                participantViewData.setAvatarBitmap(avatarImageBitmap)

            localOptions.setParticipantViewData(participantViewData)
            isAnythingChanged = true
        }

        SettingsFeatures.getTitle()?.let { title ->
            if (title.isNotEmpty()) {
                val setupScreenViewData = CallCompositeSetupScreenViewData().setTitle(title)
                SettingsFeatures.getSubtitle()?.let { subTitle ->
                    if (subTitle.isNotEmpty()) {
                        setupScreenViewData.setSubtitle(subTitle)
                    }
                }

                localOptions.setSetupScreenViewData(setupScreenViewData)
                isAnythingChanged = true
            }
        }
        SettingsFeatures.getSkipSetupScreenFeatureOption()?.let {
            localOptions.setSkipSetupScreen(it)
            isAnythingChanged = true
        }
        SettingsFeatures.getAudioOnlyByDefaultOption()?.let {
            localOptions.setAudioVideoMode(
                if (it) {
                    CallCompositeAudioVideoMode.AUDIO_ONLY
                } else {
                    CallCompositeAudioVideoMode.AUDIO_AND_VIDEO
                },
            )
            isAnythingChanged = true
        }
        SettingsFeatures.getCameraOnByDefaultOption()?.let {
            localOptions.setCameraOn(it)
            isAnythingChanged = true
        }
        SettingsFeatures.getMicOnByDefaultOption()?.let {
            localOptions.setMicrophoneOn(it)
            isAnythingChanged = true
        }

        val autoStartCaptions = SettingsFeatures.getAutoStartCaptionsEnabled()
        val defaultSpokenLanguage = SettingsFeatures.getCaptionsDefaultSpokenLanguage()

        if (autoStartCaptions != null || defaultSpokenLanguage?.isNotEmpty() == true) {
            val captionsViewData =
                CallCompositeCaptionsOptions()

            autoStartCaptions.let {
                if (it == true) {
                    captionsViewData.setCaptionsOn(true)
                }
            }

            defaultSpokenLanguage.let {
                captionsViewData.setSpokenLanguage(it)
            }

            localOptions.setCaptionsOptions(captionsViewData)
            isAnythingChanged = true
        }

        callScreenOptions().let {
            localOptions.callScreenOptions = it
            isAnythingChanged = true
        }

        setupScreenOptions()?.let {
            localOptions.setupScreenOptions = it
            isAnythingChanged = true
        }



        return if (isAnythingChanged) localOptions else null
    }

    private fun subscribeToEvents(
        context: Context,
        callComposite: CallComposite,
    ) {


        val callStateEventHandler: ((CallCompositeCallStateChangedEvent) -> Unit) = {
            callCompositeCallStateStateFlow.value = it.code.toString()
            var callStartTime: Date? = null

            toast(context, "Call State: ${it.code}. start time: $callStartTime ")
        }

        callComposite.addOnCallStateChangedEventHandler(callStateEventHandler)

        callComposite.addOnUserReportedEventHandler {
            toast(context, "onUserReportedEvent: ${it.userMessage}")
        }
//        callComposite.addOnUserReportedEventHandler(UserReportedIssueHandler(context.applicationContext as Application))

        val onDismissedEventHandler: ((CallCompositeDismissedEvent) -> Unit) = {
            remoteParticipantsCount = 0
            toast(
                context,
                "onDismissed: errorCode: ${it.errorCode}, cause: ${it.cause?.message}"
            )
        }
        callComposite.addOnDismissedEventHandler(onDismissedEventHandler)

        callComposite.addOnRemoteParticipantLeftEventHandler { event ->
            toast(context, "Remote participant removed: ${event.identifiers.count()}")
//            event.identifiers.forEach {
//                Log.d(CallLauncherActivity.TAG, "Remote participant removed: ${it.rawId}")
//            }
        }

        callComposite.addOnPictureInPictureChangedEventHandler {
            toast(context, "isInPictureInPicture: " + it.isInPictureInPicture)
        }

        callComposite.addOnRemoteParticipantJoinedEventHandler { event ->
            toast(context, message = "Joined ${event.identifiers.count()} remote participants")
//            event.identifiers.forEach {
//                Log.d(CallLauncherActivity.TAG, "Remote participant joined: ${it.rawId}")
//            }
            remoteParticipantsCount += event.identifiers.count()
            val titleUpdateCount = SettingsFeatures.getCallScreenInformationTitleUpdateParticipantCount()
            if (titleUpdateCount != 0 && titleUpdateCount <= remoteParticipantsCount) {
                callScreenHeaderOptions?.let {
                    it.title = "Custom Call Screen Header: $remoteParticipantsCount participants"
                }
            }
            val subtitleUpdateCount = SettingsFeatures.getCallScreenInformationSubtitleUpdateParticipantCount()
            if (subtitleUpdateCount != 0 && subtitleUpdateCount <= remoteParticipantsCount) {
                callScreenHeaderOptions?.let {
                    it.subtitle = "Custom Call Screen Header: $remoteParticipantsCount participants"
                }
            }
        }

        callComposite.addOnAudioSelectionChangedEventHandler { event ->
            toast(context, message = "Audio selection changed to ${event.audioSelectionMode}")
        }

        callComposite.addOnIncomingCallEventHandler {
            toast(context, "Incoming call. ${it.callId}")
            onIncomingCall(it)
        }

        callComposite.addOnIncomingCallCancelledEventHandler {
            toast(context, "Incoming call cancelled. ${it.callId}")
            onIncomingCallCancelled(it)
        }


    }

    fun dismissCallComposite() {
        callComposite?.dismiss()
        callComposite = null
    }

    fun bringCallCompositeToForeground(context: Context) {
        callComposite?.bringToForeground(context)
    }

    fun getCallHistory(context: Context, acsToken: String, displayName: String): List<CallCompositeCallHistoryRecord>? {
        createCallCompositeAndSubscribeToEvents(context, acsToken, displayName)
        return callComposite?.getDebugInfo(context)?.callHistoryRecords
    }

    fun acceptIncomingCall(applicationContext: Context, acsToken: String, displayName: String) {
        hideIncomingCallNotification()
        createCallCompositeAndSubscribeToEvents(applicationContext, acsToken, displayName)
        val localOptions = getLocalOptions(applicationContext)
        if (localOptions == null) {
            callComposite?.accept(applicationContext, incomingCallId)
        } else {
            callComposite?.accept(applicationContext, incomingCallId, localOptions)
        }
    }

    fun declineIncomingCall() {
        hideIncomingCallNotification()
        callComposite?.reject(incomingCallId)
    }

    fun hold() {
        callComposite?.hold()
    }

    fun resume() {
        callComposite?.resume()
    }

    fun hideIncomingCallNotification() {
        val notificationManager = NotificationManagerCompat.from(context)
        notificationManager.cancel(1)
    }

    fun handleIncomingCall(
        value: Map<String, String>,
        acsIdentityToken: String,
        displayName: String,
        applicationContext: Context
    ) {
        createCallCompositeAndSubscribeToEvents(
            applicationContext,
            acsIdentityToken,
            displayName
        )
        if (callComposite?.callState == CallCompositeCallStateCode.CONNECTED) {
            toast(applicationContext, "Incoming call ignored as there is already an active call.")
            return
        }
        callComposite?.handlePushNotification(CallCompositePushNotification(value))
    }

    fun registerPush(applicationContext: Context, acsToken: String, displayName: String) {
        createCallCompositeAndSubscribeToEvents(applicationContext, acsToken, displayName)
        FirebaseMessaging.getInstance().token.addOnCompleteListener { task ->
            if (!task.isSuccessful) {
                throw task.exception ?: IllegalStateException("Failed to get Firebase token")
            }
            val deviceRegistrationToken = task.result
            try {
                callComposite?.registerPushNotification(deviceRegistrationToken)
                    ?.whenComplete { _, throwable ->
                        if (throwable != null) {
                            toast(applicationContext, "Register push failed.")
                            throw throwable
                        } else {
                            toast(applicationContext, "Register push success.")
                        }
                    }
            } catch (e: Exception) {
                e.message?.let { toast(applicationContext, it) }
            }
        }
    }

    fun unregisterPush(applicationContext: Context, acsToken: String, displayName: String) {
        createCallCompositeAndSubscribeToEvents(applicationContext, acsToken, displayName)
        try {
            callComposite?.unregisterPushNotification()
                ?.whenComplete { _, throwable ->
                    if (throwable != null) {
                        toast(applicationContext, "Unregister push failed.")
                        throw throwable
                    } else {
                        toast(applicationContext, "Unregister push success.")
                    }
                }
        } catch (e: Exception) {
            e.message?.let { toast(applicationContext, it) }
        }
    }

    private fun createCallCompositeAndSubscribeToEvents(
        context: Context,
        acsToken: String,
        displayName: String,
        identity: String = "",
    ) {
        if (this.callComposite != null) {
            return
        }
        val callComposite = createCallComposite(acsToken, displayName, context, identity)
        subscribeToEvents(context, callComposite)
        this.callComposite = callComposite
    }

    private fun onIncomingCall(incomingCall: CallCompositeIncomingCallEvent) {
        incomingCallId = incomingCall.callId
        showNotificationForIncomingCall(incomingCall)
    }

    private fun onIncomingCallCancelled(callCancelled: CallCompositeIncomingCallCancelledEvent) {
        incomingCallId = null
        hideIncomingCallNotification()
    }

    private fun createCallComposite(
        acsToken: String,
        displayName: String,
        context: Context,
        identity: String
    ): CallComposite {
        val communicationTokenRefreshOptions =
            CommunicationTokenRefreshOptions({ acsToken }, true)
        val communicationTokenCredential =
            CommunicationTokenCredential(communicationTokenRefreshOptions)
        val callScreenOrientation =
            SettingsFeatures.orientation(SettingsFeatures.callScreenOrientation())
        val setupScreenOrientation =
            SettingsFeatures.orientation(SettingsFeatures.setupScreenOrientation())

        val callCompositeBuilder = CallCompositeBuilder()

        if (identity.isNotEmpty()) {
            callCompositeBuilder.userId(CommunicationIdentifier.fromRawId(identity))
        }

        if (setupScreenOrientation != null) {
            callCompositeBuilder.setupScreenOrientation(setupScreenOrientation)
        }

        if (SettingsFeatures.getDisableInternalPushForIncomingCallCheckbox()) {
            callCompositeBuilder.disableInternalPushForIncomingCall(true)
        }

        if (callScreenOrientation != null) {
            callCompositeBuilder.callScreenOrientation(callScreenOrientation)
        }

        SettingsFeatures.locale(SettingsFeatures.language())?.let {
            val isRtl = SettingsFeatures.getLayoutDirection()
            callCompositeBuilder
                .localization(
                    if (isRtl != null) {
                        CallCompositeLocalizationOptions(it, isRtl)
                    } else {
                        CallCompositeLocalizationOptions(it)
                    },
                )
        }

        if (!SettingsFeatures.getUseDeprecatedLaunch()) {
            callCompositeBuilder.credential(communicationTokenCredential)
            callCompositeBuilder.applicationContext(context)
            callCompositeBuilder.displayName(displayName)
        }

        callScreenOptions().let { callCompositeBuilder.callScreenOptions(it) }

        setupScreenOptions()?.let { callCompositeBuilder.setupScreenOptions(it) }



        if (SettingsFeatures.enableMultitasking() != null) {
            val multitaskingOptions =
                if (SettingsFeatures.enablePipWhenMultitasking() != null) {
                    CallCompositeMultitaskingOptions(
                        SettingsFeatures.enableMultitasking(),
                        SettingsFeatures.enablePipWhenMultitasking(),
                    )
                } else {
                    CallCompositeMultitaskingOptions(
                        SettingsFeatures.enableMultitasking(),
                    )
                }

            callCompositeBuilder.multitasking(multitaskingOptions)
        }

        return callCompositeBuilder.build()
    }

    private fun callScreenOptions(): CallCompositeCallScreenOptions? {
        var callScreenOptions: CallCompositeCallScreenOptions? = null
        if (SettingsFeatures.getDisplayLeaveCallConfirmationValue() != null) {
            callScreenOptions = CallCompositeCallScreenOptions()

            val controlBarOptions = CallCompositeCallScreenControlBarOptions()
            callScreenOptions.setControlBarOptions(controlBarOptions)

            controlBarOptions.setLeaveCallConfirmation(
                if (SettingsFeatures.getDisplayLeaveCallConfirmationValue() == true) CallCompositeLeaveCallConfirmationMode.ALWAYS_ENABLED
                else CallCompositeLeaveCallConfirmationMode.ALWAYS_DISABLED
            )
        }

        if (SettingsFeatures.getAddCustomButtons() == true) {
            callScreenOptions = callScreenOptions ?: CallCompositeCallScreenOptions()
            if (callScreenOptions.controlBarOptions == null)
                callScreenOptions.controlBarOptions = CallCompositeCallScreenControlBarOptions()

            with(callScreenOptions) {
                controlBarOptions.cameraButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "cameraButton clicked") }

                controlBarOptions.microphoneButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "microphoneButton clicked") }

                controlBarOptions.audioDeviceButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "audioDeviceButton clicked") }

                controlBarOptions.liveCaptionsButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "liveCaptionsButton clicked") }

                controlBarOptions.liveCaptionsToggleButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "liveCaptionsToggleButton clicked") }

                controlBarOptions.spokenLanguageButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "spokenLanguageButton clicked") }

                controlBarOptions.captionsLanguageButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "captionsLanguageButton clicked") }

                controlBarOptions.reportIssueButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "reportIssueButton clicked") }

                controlBarOptions.shareDiagnosticsButton = CallCompositeButtonViewData()
                    .setOnClickHandler { toast(it.context, "shareDiagnosticsButton clicked") }

                if (controlBarOptions == null)
                    controlBarOptions = CallCompositeCallScreenControlBarOptions()

            }
        }
        if (!SettingsFeatures.getCallScreenInformationTitle().isNullOrEmpty() ||
            !SettingsFeatures.getCallScreenInformationSubtitle().isNullOrEmpty() ||
            /* <CALL_START_TIME>
            SettingsFeatures.getCallScreenShowCallDuration() != null ||
            </CALL_START_TIME> */
            SettingsFeatures.getCallScreenInformationTitleUpdateParticipantCount() != 0 ||
            SettingsFeatures.getCallScreenInformationSubtitleUpdateParticipantCount() != 0
        ) {
            callScreenOptions = callScreenOptions ?: CallCompositeCallScreenOptions()

            callScreenHeaderOptions = callScreenHeaderOptions
                ?: CallCompositeCallScreenHeaderViewData()
            SettingsFeatures.getCallScreenInformationTitle()?.let {
                if (it.isNotEmpty()) {
                    callScreenHeaderOptions?.title = it
                }
            }
            SettingsFeatures.getCallScreenInformationSubtitle()?.let {
                if (it.isNotEmpty()) {
                    callScreenHeaderOptions?.subtitle = it
                }
            }
            /* <CALL_START_TIME>
            SettingsFeatures.getCallScreenShowCallDuration()?.let {
                callScreenHeaderOptions?.showCallDuration = it
            }
            </CALL_START_TIME> */
        }
        if (SettingsFeatures.getAddCustomButtons() == true) {
            val headerButton1 =
                CallCompositeCustomButtonViewData(
                    UUID.randomUUID().toString(),
                    R.drawable.ic_menu_call,
                    "Header Button 1",
                    fun(it: CallCompositeCustomButtonClickEvent) {
                        toast(it.context, "Header Button 1 clicked")
                    }
                )
            val headerButton2 =
                CallCompositeCustomButtonViewData(
                    UUID.randomUUID().toString(),
                    R.drawable.ic_menu_call,
                    "Header Button 2",
                    fun(it: CallCompositeCustomButtonClickEvent) {
                        toast(it.context, "Header Button 2 clicked")
                    }
                )
            callScreenHeaderOptions = callScreenHeaderOptions
                ?: CallCompositeCallScreenHeaderViewData()
            callScreenHeaderOptions?.customButtons = listOf(headerButton1, headerButton2)
        }
        callScreenOptions?.setHeaderViewData(callScreenHeaderOptions)
        return callScreenOptions
    }

    private fun setupScreenOptions(): CallCompositeSetupScreenOptions? {

        var setupScreenOptions: CallCompositeSetupScreenOptions? = null

        if (SettingsFeatures.getSetupScreenCameraEnabledValue() != null) {
            setupScreenOptions = CallCompositeSetupScreenOptions()
            setupScreenOptions.setCameraButtonEnabled(SettingsFeatures.getSetupScreenCameraEnabledValue())
        }

        if (SettingsFeatures.getSetupScreenMicEnabledValue() != null) {
            setupScreenOptions = setupScreenOptions ?: CallCompositeSetupScreenOptions()
            setupScreenOptions.setMicrophoneButtonEnabled(SettingsFeatures.getSetupScreenMicEnabledValue())
        }

        if (SettingsFeatures.getAddCustomButtons() == true) {
            val micButton = CallCompositeButtonViewData()
                .setOnClickHandler { toast(it.context, "MicrophoneButton clicked") }

            val audioDeviceButton = CallCompositeButtonViewData()
                .setOnClickHandler { toast(it.context, "AudioDeviceButton clicked") }

            val cameraButton = CallCompositeButtonViewData()
                .setOnClickHandler {
                    micButton.isVisible = !micButton.isVisible
                    audioDeviceButton.isEnabled = !audioDeviceButton.isEnabled
                    toast(it.context, "CameraButton clicked")
                }
            setupScreenOptions = setupScreenOptions ?: CallCompositeSetupScreenOptions()
            setupScreenOptions.setCameraButton(cameraButton)
            setupScreenOptions.setMicrophoneButton(micButton)
            setupScreenOptions.setAudioDeviceButton(audioDeviceButton)
        }

        return setupScreenOptions
    }

    private fun toast(
        context: Context,
        message: String,
    ) {
        Log.i("ACSCallingUI", message)
        Handler(Looper.getMainLooper()).post {
            Toast.makeText(context.applicationContext, "Debug: $message", Toast.LENGTH_SHORT).show()
        }
    }


    private fun canUseFullScreenIntent(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) { // Android 14+
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.canUseFullScreenIntent()
        } else {
            // For Android 13 and below, check if permission is declared
            ContextCompat.checkSelfPermission(
                context,
                android.Manifest.permission.USE_FULL_SCREEN_INTENT
            ) == android.content.pm.PackageManager.PERMISSION_GRANTED
        }
    }

    private fun requestFullScreenIntentPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            try {
                val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT).apply {
                    data = Uri.parse("package:${context.packageName}")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(intent)
            } catch (e: Exception) {
                Log.e("CallCompositeManager", "Failed to open full-screen intent settings", e)
                // Fallback to app settings
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.parse("package:${context.packageName}")
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                context.startActivity(intent)
            }
        }
    }

    @SuppressLint("MissingPermission")
    private fun showNotificationForIncomingCall(notification: CallCompositeIncomingCallEvent) {
        context.let { context ->
            // Create notification channel first
            createNotificationChannel()

            // Create accept and decline intents
            val acceptIntent = Intent(context, IncomingCallActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra(IncomingCallActivity.DISPLAY_NAME, notification.callerDisplayName)
                putExtra("CALL_ID", notification.callId)
                putExtra("ACTION", "ACCEPT")
            }

            // Create decline intent
            val declineIntent = Intent(context, IncomingCallActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra(IncomingCallActivity.DISPLAY_NAME, notification.callerDisplayName)
                putExtra("CALL_ID", notification.callId)
                putExtra("ACTION", "DECLINE")
            }

            // Full screen intent (same as accept for now)
            val fullScreenIntent = Intent(context, IncomingCallActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra(IncomingCallActivity.DISPLAY_NAME, notification.callerDisplayName)
                putExtra("CALL_ID", notification.callId)
                putExtra("ACTION", "FULL_SCREEN")
            }

            val fullScreenPendingIntent = PendingIntent.getActivity(
                context, 0, fullScreenIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val acceptPendingIntent = PendingIntent.getActivity(
                context, 1, acceptIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val declinePendingIntent = PendingIntent.getActivity(
                context, 2, declineIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )


            val builder: NotificationCompat.Builder =
                NotificationCompat.Builder(context, "acs")
                    .setSmallIcon(R.drawable.ic_menu_call)
                    .setDefaults(NotificationCompat.DEFAULT_ALL)
                    .setWhen(System.currentTimeMillis())
                    .setContentTitle("Incoming Call")
                    .setContentText(notification.callerDisplayName ?: "Unknown caller")
                    .addAction(
                        R.drawable.ic_menu_call,
                        "Accept",
                        acceptPendingIntent
                    )
                    .addAction(
                        R.drawable.ic_menu_call,
                        "Decline",
                        declinePendingIntent
                    )
                    .setStyle(NotificationCompat.DecoratedCustomViewStyle())
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                    .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE))
                    .setOngoing(true)
                    .setAutoCancel(true)
                    .setFullScreenIntent(fullScreenPendingIntent, true)

            // Log permission status for debugging
            val hasPermission = canUseFullScreenIntent()
            Log.d("CallCompositeManager", "Can use full-screen intent: $hasPermission")

                builder.setFullScreenIntent(fullScreenPendingIntent, true)
                Log.d("CallCompositeManager", "Full-screen intent set")


            val notificationManager = NotificationManagerCompat.from(context)
            notificationManager.notify(1, builder.build())

            Log.d("CallCompositeManager", "Incoming call notification shown")
        }
    }

    private fun createNotificationChannel() {
        val channelId = "acs"
        val channelName = "Incoming Calls"
        val importance = NotificationManager.IMPORTANCE_HIGH
        val channel = NotificationChannel(channelId, channelName, importance).apply {
            description = "Channel for incoming call notifications"
            enableLights(true)
            enableVibration(true)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
            setBypassDnd(true) // Allow to bypass Do Not Disturb
            setShowBadge(true)
        }

        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }

    // Public method to check and request permission
    fun ensureFullScreenIntentPermission(): Boolean {
        val hasPermission = canUseFullScreenIntent()
        Log.d("CallCompositeManager", "Full-screen intent permission status: $hasPermission")

        if (!hasPermission && Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            Log.d("CallCompositeManager", "Requesting full-screen intent permission")
            requestFullScreenIntentPermission()
        }

        return hasPermission
    }
}