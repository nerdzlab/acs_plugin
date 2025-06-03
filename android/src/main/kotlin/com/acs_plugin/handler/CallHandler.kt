package com.acs_plugin.handler

import android.app.Activity
import android.content.Context
import android.content.SharedPreferences
import com.acs_plugin.Constants
import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.CallCompositeBuilder
import com.acs_plugin.calling.models.CallCompositeJoinLocator
import com.acs_plugin.calling.models.CallCompositeLocalOptions
import com.acs_plugin.calling.models.CallCompositeRoomLocator
import com.acs_plugin.data.UserData
import com.acs_plugin.extension.falseIfNull
import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.communication.common.CommunicationTokenRefreshOptions
import com.azure.android.communication.common.CommunicationUserIdentifier
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.json.Json

class CallHandler(
    private val context: Context,
    private val activity: Activity?
) : MethodHandler {

    private val sharedPreferences: SharedPreferences by lazy {
        context.getSharedPreferences(Constants.Prefs.PREFS_NAME, Context.MODE_PRIVATE)
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

    override fun handle(call: MethodCall, result: MethodChannel.Result): Boolean {
        return when (call.method) {
            Constants.MethodChannels.INITIALIZE_ROOM_CALL -> {
                try {
                    val args = call.arguments as? Map<*, *>
                    val roomId = args?.get(Constants.Arguments.ROOM_ID) as? String
                    val isChatEnabled = args?.get(Constants.Arguments.IS_CHAT_ENABLED) as? Boolean
                    val isRejoined = args?.get(Constants.Arguments.IS_REJOINED) as? Boolean

                    if (roomId != null) {
                        initializeRoomCall(roomId, isChatEnabled.falseIfNull(), isRejoined.falseIfNull(), result)
                    } else {
                        result.error("INVALID_ARGUMENTS", "RoomId are required", null)
                    }

                    true
                } catch (e: Exception) {
                    result.error("ERROR", e.message, null)
                    true
                }
            }

            else -> false
        }
    }

    private fun initializeRoomCall(
        roomId: String,
        isChatEnabled: Boolean,
        isRejoined: Boolean,
        result: MethodChannel.Result
    ) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
            return
        }

        if (userData == null) {
            result.error("NO_USER_DATA", "User data not available", null)
            return
        }

        val communicationTokenRefreshOptions = CommunicationTokenRefreshOptions({ userData?.token }, true)
        val communicationTokenCredential = CommunicationTokenCredential(communicationTokenRefreshOptions)

        val localOptions = CallCompositeLocalOptions().apply {
            setSkipSetupScreen(isRejoined)
            setChatEnabled(isChatEnabled)
        }

        val locator: CallCompositeJoinLocator = CallCompositeRoomLocator(roomId)
        val callComposite: CallComposite = CallCompositeBuilder()
            .applicationContext(this.context)
            .credential(communicationTokenCredential)
            .displayName(userData?.name)
            .userId(CommunicationUserIdentifier(userData?.userId))
            .build()

        callComposite.launch(this.activity, locator, localOptions)
        result.success(null)
    }
}