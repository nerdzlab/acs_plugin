package com.example.acs_plugin_example

import android.app.Application
import android.content.Context
import android.content.SharedPreferences
import androidx.work.Configuration
import androidx.work.WorkManager
import com.acs_plugin.Constants
import com.acs_plugin.data.UserData
import com.azure.android.communication.chat.implementation.notifications.fcm.RegistrationRenewalWorkerFactory
import com.azure.android.communication.common.CommunicationTokenCredential
import com.jakewharton.threetenabp.AndroidThreeTen
import java9.util.function.Consumer
import kotlinx.serialization.json.Json

class AcsApp : Application(), Configuration.Provider {

    private var exceptionHandler: Consumer<Throwable?> = Consumer<Throwable?> { }

    private val sharedPreferences: SharedPreferences by lazy {
        applicationContext.getSharedPreferences(Constants.Prefs.PREFS_NAME, Context.MODE_PRIVATE)
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

    override fun onCreate() {
        super.onCreate()
        WorkManager.initialize(this, workManagerConfiguration)
        AndroidThreeTen.init(this)
    }

    override fun getWorkManagerConfiguration(): Configuration =
        userData?.token?.let { token ->
            Configuration.Builder().setWorkerFactory(
                RegistrationRenewalWorkerFactory(
                    CommunicationTokenCredential(token),
                    exceptionHandler
                )
            ).build()
        } ?: Configuration.Builder().build()
}