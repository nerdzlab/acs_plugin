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
import com.azure.android.communication.calling.CallAgent
import com.azure.android.communication.calling.CallAgentOptions
import com.azure.android.communication.calling.CallClient
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

    private var token: String? = null

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

    override fun onFirebaseTokenReceived(token: String) {
        super.onFirebaseTokenReceived(token)
        this.token = token
    }

    override fun onUserReceived() {
        super.onUserReceived()
        createCallAgent()
    }

    override fun handle(call: MethodCall, result: MethodChannel.Result): Boolean {
        return when (call.method) {
            Constants.MethodChannels.INITIALIZE_ROOM_CALL -> {
                try {
                    val args = call.arguments as? Map<*, *>
                    val roomId = args?.get(Constants.Arguments.ROOM_ID) as? String
                    val callId = args?.get(Constants.Arguments.CALL_ID) as? String
                    val whiteboardId = args?.get(Constants.Arguments.WHITEBOARD_ID) as? String
                    val isChatEnabled = args?.get(Constants.Arguments.IS_CHAT_ENABLED) as? Boolean
                    val isRejoined = args?.get(Constants.Arguments.IS_REJOINED) as? Boolean

                    if (roomId != null && callId != null && whiteboardId != null) {
                        initializeRoomCall(
                            roomId = roomId,
                            callId = callId,
                            whiteboardId = whiteboardId,
                            isChatEnabled = isChatEnabled.falseIfNull(),
                            isRejoined = isRejoined.falseIfNull(),
                            result = result
                        )
                    } else {
                        result.error("INVALID_ARGUMENTS", "RoomId are required", null)
                    }

                    true
                } catch (e: Exception) {
                    result.error("ERROR", e.message, null)
                    true
                }
            }


            Constants.MethodChannels.START_ONE_ON_ONE_CALL -> {
                try {
                    val args = call.arguments as? Map<*, *>
                    val participantsId = args?.get(Constants.Arguments.PARTICIPANTS_ID) as? List<String>

                    if (participantsId != null) {
                        startOneOnOneCall(
                            participantsId = participantsId,
                            result = result
                        )
                    } else {
                        result.error("INVALID_ARGUMENTS", "Token, participantId and userId are required", null)
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
        callId: String,
        whiteboardId: String,
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
            setCallId(callId)
            setWhiteboardId(whiteboardId)
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

    private fun createCallAgent(): CallAgent? {
        val callClient = CallClient()
        val tokenCredential = CommunicationTokenCredential(userData?.token)
        val callAgentOptions = CallAgentOptions()
        val callAgent = callClient.createCallAgent(context, tokenCredential, callAgentOptions).get()
        callAgent.registerPushNotification(token).get()
        return callAgent
    }

    private fun startOneOnOneCall(
        participantsId: List<String>,
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

        val communicationTokenRefreshOptions = CommunicationTokenRefreshOptions(
            { userData?.token },
            true
        )
        val communicationTokenCredential = CommunicationTokenCredential(communicationTokenRefreshOptions)

        val participants = participantsId.map { CommunicationUserIdentifier(it) }

        val callComposite: CallComposite = CallCompositeBuilder()
            .applicationContext(this.context)
            .credential(communicationTokenCredential)
            .displayName(userData?.name)
            .userId(CommunicationUserIdentifier(userData?.userId))
            .build()

        val callCompositeLocalOptions = CallCompositeLocalOptions()
        participants.firstOrNull()?.let { remoteParticipant ->
            callComposite.launch(activity, participants, callCompositeLocalOptions)
            result.success(null)
        } ?: run {
            result.error("NO_PARTICIPANTS", "No participants provided", null)
        }
    }
}