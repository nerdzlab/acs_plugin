package com.acs_plugin

import android.content.Context
import android.content.Intent
import android.os.PowerManager
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.acs_plugin.calling.models.CallCompositePushNotification
import com.acs_plugin.calling.models.CallCompositePushNotificationEventType
import com.acs_plugin.utils.IntentHelper
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FBMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        if (remoteMessage.data.isNotEmpty()) {
            val pushNotificationInfo = CallCompositePushNotification(remoteMessage.data)
            Log.d("NOTIFICATION_RECEIVED", "onMessageReceived - ${pushNotificationInfo.eventType}")
            if (pushNotificationInfo.eventType == CallCompositePushNotificationEventType.INCOMING_CALL ||
                pushNotificationInfo.eventType == CallCompositePushNotificationEventType.INCOMING_GROUP_CALL
            ) {
                wakeAppIfScreenOff()
                sendIntent(IntentHelper.HANDLE_INCOMING_CALL_PUSH, remoteMessage)
            } else {
                sendIntent(IntentHelper.CLEAR_PUSH_NOTIFICATION, remoteMessage)
            }
        }
    }

    private fun sendIntent(tag: String, remoteMessage: RemoteMessage?) {
        Log.d("NOTIFICATION_RECEIVED", "Passing push notification to Activity: ${remoteMessage?.data}")
        val intent = Intent("acs_chat_intent")
        intent.putExtra("PushNotificationPayload", remoteMessage)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }

    private fun wakeAppIfScreenOff() {
        val pm = applicationContext.getSystemService(Context.POWER_SERVICE) as PowerManager
        val screenIsOn = pm.isInteractive // check if screen is on

        if (!screenIsOn) {
            val wakeLockTag: String = applicationContext.packageName + "WAKELOCK"
            val wakeLock = pm.newWakeLock(
                PowerManager.FULL_WAKE_LOCK or
                        PowerManager.ACQUIRE_CAUSES_WAKEUP or
                        PowerManager.ON_AFTER_RELEASE,
                wakeLockTag
            )

            // acquire will turn on the display
            wakeLock.acquire(10 * 60 * 1000L /*10 minutes*/)

            wakeLock.release()
        }
    }
}