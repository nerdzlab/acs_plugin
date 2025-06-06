package com.acs_plugin.handler

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import com.acs_plugin.Constants
import com.acs_plugin.data.UserData
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.serialization.json.Json

class UserDataHandler(
    private val context: Context,
    private val channel: MethodChannel,
    private val onUserDataReceived: (UserData) -> Unit
) : MethodHandler {

    private var userData: UserData? = null
        set(value) {
            field = value
            value?.let {
                saveUserData(it)
                onUserDataReceived(it)
            }
        }

    private val sharedPreferences: SharedPreferences by lazy {
        context.getSharedPreferences(Constants.Prefs.PREFS_NAME, Context.MODE_PRIVATE)
    }

    init {
        loadSavedUserData()
    }

    private fun loadSavedUserData() {
        val userDataJson = sharedPreferences.getString(Constants.Prefs.USER_DATA_KEY, null)
        userDataJson?.let {
            userData = Json.decodeFromString<UserData>(it)
        }
    }

    private fun saveUserData(userData: UserData) {
        val userDataJson = Json.encodeToString(UserData.serializer(), userData)
        sharedPreferences.edit { putString(Constants.Prefs.USER_DATA_KEY, userDataJson) }
    }

    override fun handle(call: MethodCall, result: MethodChannel.Result): Boolean {
        return when (call.method) {
            Constants.MethodChannels.SET_USER_DATA -> {
                try {
                    val arguments = call.arguments as? Map<*, *>
                    val token = arguments?.get(Constants.Arguments.TOKEN) as? String
                    val name = arguments?.get(Constants.Arguments.NAME) as? String
                    val userId = arguments?.get(Constants.Arguments.USER_ID) as? String

                    if (token != null && name != null && userId != null) {
                        userData = UserData(token = token, name = name, userId = userId)
                        result.success(null)
                    } else {
                        result.error(
                            "INVALID_ARGUMENTS", "Token, name and userId are required", null
                        )
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


    fun getUserData(): UserData? = userData
}