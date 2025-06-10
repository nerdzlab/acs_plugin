package com.acs_plugin

import android.content.Intent
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.azure.android.communication.chat.models.ChatPushNotification
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import java.util.concurrent.Semaphore

class FBMessagingService : FirebaseMessagingService() {

    private val TAG = "MyFirebaseMsgService"
    var initCompleted = Semaphore(1)

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        try {
            Log.d(TAG, "Incoming push notification.")

            initCompleted.acquire()

            if (remoteMessage.data.isNotEmpty()) {
                val chatPushNotification = ChatPushNotification().setPayload(remoteMessage.data)
                sendPushNotificationToActivity(chatPushNotification)
            }

            initCompleted.release()
        } catch (e: InterruptedException) {
            Log.e(TAG, "Error receiving push notification.")
        }
    }

    private fun sendPushNotificationToActivity(chatPushNotification: ChatPushNotification) {
        Log.d(TAG, "Passing push notification to Activity: ${chatPushNotification.payload}")
        val intent = Intent("acs_chat_intent")
        intent.putExtra("PushNotificationPayload", chatPushNotification)
        LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
    }
}