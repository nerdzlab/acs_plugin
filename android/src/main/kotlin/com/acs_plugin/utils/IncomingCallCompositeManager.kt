package com.acs_plugin.utils

import android.annotation.SuppressLint
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.Person
import com.acs_plugin.R
import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.CallCompositeBuilder
import com.acs_plugin.calling.models.*
import com.acs_plugin.data.enum.OneOnOneCallingAction
import com.acs_plugin.ui.IncomingCallActivity
import com.azure.android.communication.common.CommunicationIdentifier
import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.communication.common.CommunicationTokenRefreshOptions
import com.google.firebase.messaging.FirebaseMessaging

class IncomingCallCompositeManager(private val context: Context) {

    private var callComposite: CallComposite? = null
    private var incomingCallId: String? = null

    private fun getLocalOptions(): CallCompositeLocalOptions {
        val localOptions = CallCompositeLocalOptions().apply {
            setCameraOn(true)
            setMicrophoneOn(true)
            setSkipSetupScreen(true)
            setChatEnabled(true)
        }

        return localOptions
    }

    private fun subscribeToEvents(callComposite: CallComposite) {
        val onDismissedEventHandler: ((CallCompositeDismissedEvent) -> Unit) = {
            Log.i("AcsOneOnOneCall", "onDismissed: errorCode: ${it.errorCode}, cause: ${it.cause?.message}")
        }
        callComposite.addOnDismissedEventHandler(onDismissedEventHandler)

        callComposite.addOnAudioSelectionChangedEventHandler { event ->
            Log.i("AcsOneOnOneCall", "Audio selection changed to ${event.audioSelectionMode}")
        }

        callComposite.addOnIncomingCallEventHandler {
            Log.i("AcsOneOnOneCall", "Incoming call. ${it.callId}")
            onIncomingCall(it)
        }

        callComposite.addOnIncomingCallCancelledEventHandler {
            Log.i("AcsOneOnOneCall", "Incoming call cancelled. ${it.callId}")
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

    fun acceptIncomingCall(applicationContext: Context, acsToken: String, displayName: String) {
        hideIncomingCallNotification()
        createCallCompositeAndSubscribeToEvents(applicationContext, acsToken, displayName)
        val localOptions = getLocalOptions()
        callComposite?.accept(applicationContext, incomingCallId, localOptions)
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
            Log.i("AcsOneOnOneCall", "Incoming call ignored as there is already an active call.")
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
                            Log.i("AcsOneOnOneCall", "Register push failed.")
                            throw throwable
                        } else {
                            Log.i("AcsOneOnOneCall","Register push success.")
                        }
                    }
            } catch (e: Exception) {
                e.message?.let { Log.i("AcsOneOnOneCall", it) }
            }
        }
    }

    fun unregisterPush(applicationContext: Context, acsToken: String, displayName: String) {
        createCallCompositeAndSubscribeToEvents(applicationContext, acsToken, displayName)
        try {
            callComposite?.unregisterPushNotification()
                ?.whenComplete { _, throwable ->
                    if (throwable != null) {
                        Log.i("AcsOneOnOneCall", "Unregister push failed.")
                        throw throwable
                    } else {
                        Log.i("AcsOneOnOneCall", "Unregister push success.")
                    }
                }
        } catch (e: Exception) {
            e.message?.let { Log.i("AcsOneOnOneCall", it) }
        }
    }

    private fun createCallCompositeAndSubscribeToEvents(
        context: Context,
        acsToken: String,
        displayName: String,
        identity: String = "",
    ) {
        if (this.callComposite != null) {
            subscribeToEvents(callComposite!!)
            return
        }
        val callComposite = createCallComposite(acsToken, displayName, context, identity)
        subscribeToEvents(callComposite)
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

        val callCompositeBuilder = CallCompositeBuilder()

        if (identity.isNotEmpty()) {
            callCompositeBuilder.userId(CommunicationIdentifier.fromRawId(identity))
        }

        callCompositeBuilder.credential(communicationTokenCredential)
        callCompositeBuilder.applicationContext(context)
        callCompositeBuilder.displayName(displayName)
        callCompositeBuilder.multitasking(CallCompositeMultitaskingOptions(true, true))

        return callCompositeBuilder.build()
    }


    @SuppressLint("MissingPermission")
    private fun showNotificationForIncomingCall(notification: CallCompositeIncomingCallEvent) {
        context.let { context ->
            createNotificationChannel()

            val acceptIntent = Intent("com.acs_plugin.CALL_ACTION").apply {
                setPackage(context.packageName) // Important: Make it explicit
                putExtra("ACTION_TYPE", OneOnOneCallingAction.ACCEPT)
                putExtra("CALL_ID", notification.callId)
                putExtra("DISPLAY_NAME", notification.callerDisplayName)
            }

            val declineIntent = Intent("com.acs_plugin.CALL_ACTION").apply {
                setPackage(context.packageName) // Important: Make it explicit
                putExtra("ACTION_TYPE", OneOnOneCallingAction.DECLINE)
                putExtra("CALL_ID", notification.callId)
                putExtra("DISPLAY_NAME", notification.callerDisplayName)
            }

            val fullScreenIntent = Intent(context, IncomingCallActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_CLEAR_TOP or Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_NEW_TASK
                putExtra(IncomingCallActivity.DISPLAY_NAME, notification.callerDisplayName)
                putExtra("CALL_ID", notification.callId)
                putExtra("DISPLAY_NAME", notification.callerDisplayName)
                putExtra("ACTION", "FULL_SCREEN")
            }

            val fullScreenPendingIntent = PendingIntent.getActivity(
                context, 0, fullScreenIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val acceptPendingIntent = PendingIntent.getBroadcast(
                context, 1, acceptIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val declinePendingIntent = PendingIntent.getBroadcast(
                context, 2, declineIntent,
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )

            val incomingCaller = Person.Builder()
                .setName(notification.callerDisplayName ?: "Unknown caller")
                .setImportant(true)
                .build()

            val builder: NotificationCompat.Builder =
                NotificationCompat.Builder(context, "acs")
                    .setSmallIcon(R.drawable.ic_menu_call)
                    .setDefaults(NotificationCompat.DEFAULT_ALL)
                    .setWhen(System.currentTimeMillis())
                    .setContentTitle("Incoming Call")
                    .setContentText(notification.callerDisplayName ?: "Unknown caller")
                    .setStyle(
                        NotificationCompat.CallStyle.forIncomingCall(incomingCaller, declinePendingIntent, acceptPendingIntent))
                    .setCategory(NotificationCompat.CATEGORY_CALL)
                    .setPriority(NotificationCompat.PRIORITY_MAX)
                    .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                    .setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_RINGTONE))
                    .setOngoing(true)
                    .setAutoCancel(true)
                    .setFullScreenIntent(fullScreenPendingIntent, true)


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
}