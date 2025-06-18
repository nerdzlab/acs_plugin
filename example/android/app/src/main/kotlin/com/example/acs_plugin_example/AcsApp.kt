package com.example.acs_plugin_example

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import androidx.work.Configuration
import androidx.work.WorkManager
import com.acs_plugin.consts.PluginConstants
import com.acs_plugin.data.UserData
import com.azure.android.communication.chat.implementation.notifications.fcm.RegistrationRenewalWorkerFactory
import com.azure.android.communication.common.CommunicationTokenCredential
import com.jakewharton.threetenabp.AndroidThreeTen
import java9.util.function.Consumer
import kotlinx.serialization.json.Json

class AcsApp : Application(), Configuration.Provider {

    private var exceptionHandler: Consumer<Throwable?> = Consumer<Throwable?> { throwable ->
        throwable?.printStackTrace()
    }

    private val sharedPreferences: SharedPreferences by lazy {
        applicationContext.getSharedPreferences(PluginConstants.Prefs.PREFS_NAME, Context.MODE_PRIVATE)
    }

    private val userData: UserData?
        get() {
            val json = sharedPreferences.getString(PluginConstants.Prefs.USER_DATA_KEY, null)
            return json?.let {
                try {
                    Json.decodeFromString<UserData>(it)
                } catch (_: Exception) {
                    null
                }
            }
        }

    override fun onCreate() {
        super.onCreate()
        AndroidThreeTen.init(this)

        try {
            WorkManager.initialize(this, workManagerConfiguration)
        } catch (e: IllegalStateException) {
            e.printStackTrace()
        }
    }

    override fun getWorkManagerConfiguration(): Configuration {
        return userData?.token?.let { token ->
            try {
                Configuration.Builder()
                    .setWorkerFactory(
                        RegistrationRenewalWorkerFactory(
                            CommunicationTokenCredential(token),
                            exceptionHandler
                        )
                    )
                    .setMinimumLoggingLevel(android.util.Log.DEBUG)
                    .build()
            } catch (e: Exception) {
                e.printStackTrace()
                Configuration.Builder()
                    .setMinimumLoggingLevel(android.util.Log.DEBUG)
                    .build()
            }
        } ?: Configuration.Builder()
            .setMinimumLoggingLevel(android.util.Log.DEBUG)
            .build()
    }
}