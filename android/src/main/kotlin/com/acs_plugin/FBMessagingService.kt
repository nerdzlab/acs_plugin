package com.acs_plugin

import android.content.SharedPreferences
import com.acs_plugin.data.UserData
import com.azure.android.communication.calling.CallAgentOptions
import com.azure.android.communication.calling.CallClient
import com.azure.android.communication.calling.PushNotificationInfo
import com.azure.android.communication.common.CommunicationTokenCredential
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import kotlinx.serialization.json.Json

class FBMessagingService : FirebaseMessagingService() {

    private val sharedPreferences: SharedPreferences by lazy {
        baseContext.getSharedPreferences(Constants.Prefs.PREFS_NAME, MODE_PRIVATE)
    }

    private val userData: UserData?
        get() {
            val json = sharedPreferences.getString(Constants.Prefs.USER_DATA_KEY, null)
            return json?.let {
                try {
                    Json.decodeFromString<UserData>(it)
                } catch (_: Exception) {
                    null
                }
            }
        }

    override fun onNewToken(token: String) {
        super.onNewToken(token)

    }

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        if (remoteMessage.getNotification() != null) {
            val callClient = CallClient()
            val tokenCredential = CommunicationTokenCredential(userData?.token)
            val callAgentOptions = CallAgentOptions()
            val callAgent = callClient.createCallAgent(baseContext, tokenCredential, callAgentOptions).get()
            callAgent.handlePushNotification(PushNotificationInfo.fromMap(remoteMessage.data))
        }
    }
}