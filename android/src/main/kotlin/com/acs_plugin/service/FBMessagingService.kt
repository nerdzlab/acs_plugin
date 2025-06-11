package com.acs_plugin.service

import android.content.Intent
import android.os.PowerManager
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.acs_plugin.Constants
import com.acs_plugin.calling.models.CallCompositePushNotification
import com.acs_plugin.calling.models.CallCompositePushNotificationEventType
import com.acs_plugin.data.enum.OneOnOneCallingAction
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FBMessagingService : FirebaseMessagingService() {

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        Log.d("NOTIFICATION_RECEIVED", "onMessageReceived - ${remoteMessage.data}")
        if (remoteMessage.data.isNotEmpty()) {
            val pushNotificationInfo = CallCompositePushNotification(remoteMessage.data)
            Log.d("NOTIFICATION_RECEIVED", "onMessageReceived - ${pushNotificationInfo.eventType}")
            if (pushNotificationInfo.eventType == CallCompositePushNotificationEventType.INCOMING_CALL ||
                pushNotificationInfo.eventType == CallCompositePushNotificationEventType.INCOMING_GROUP_CALL
            ) {
                wakeAppIfScreenOff()
                sendIntent(Constants.IntentDataKeys.HANDLE_INCOMING_CALL_PUSH, remoteMessage)
            } else if (pushNotificationInfo.eventType == CallCompositePushNotificationEventType.STOP_RINGING) {
                val intent = Intent("acs_chat_intent")
                intent.putExtra(Constants.Arguments.PUSH_NOTIFICATION_DATA, remoteMessage)
                intent.putExtra(Constants.Arguments.ACTION_TYPE, OneOnOneCallingAction.STOP_CALL)
                LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
            } else {
                sendIntent(Constants.IntentDataKeys.CLEAR_PUSH_NOTIFICATION, remoteMessage)
            }
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
    }

    private fun sendIntent(tag: String, remoteMessage: RemoteMessage?) {
        Log.d("NOTIFICATION_RECEIVED", "Passing push notification to Activity: ${remoteMessage?.data}")
        val intent = Intent("acs_chat_intent")
        intent.putExtra(Constants.Arguments.PUSH_NOTIFICATION_DATA, remoteMessage)
        intent.putExtra(Constants.Arguments.ACTION_TYPE, OneOnOneCallingAction.INCOMING_CALL)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }

    private fun wakeAppIfScreenOff() {
        val pm = applicationContext.getSystemService(POWER_SERVICE) as PowerManager
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