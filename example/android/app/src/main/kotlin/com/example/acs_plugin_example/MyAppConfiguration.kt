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

class MyAppConfiguration : Application(), Configuration.Provider {

    var exceptionHandler: Consumer<Throwable?> = object : Consumer<Throwable?> {

        override fun accept(t: Throwable?) {

        }

    }

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

    override fun getWorkManagerConfiguration(): Configuration = Configuration.Builder().setWorkerFactory(
        RegistrationRenewalWorkerFactory(
            CommunicationTokenCredential("eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNV8wMDAwMDAyNy1iNjUwLWUxODQtNWI0Mi1hZDNhMGQwMDRkNjEiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDk1NDU5NjAiLCJleHAiOjE3NDk2MzIzNjAsInJnbiI6ImRlIiwiYWNzU2NvcGUiOiJjaGF0LHZvaXAiLCJyZXNvdXJjZUlkIjoiNmQxNDEzY2YtMmQyNC00MTkxLWE1NzAtMTFkYTkxNmU4NDI1IiwicmVzb3VyY2VMb2NhdGlvbiI6Imdlcm1hbnkiLCJpYXQiOjE3NDk1NDU5NjB9.i1XZbKIVqYBxhQAj3mxB76pBdTM5PB-dtlc_4b76p-qWNWeYyl7-ZYlnW6alNY8IO9nsWUv60TITSszIB_jYQs2akUyCHhT9BqMBtgxQpJncEv45TXfaH1dR0NVtbW_c17GlMKXTpCPzScJPAVxKTgRY1qHTM5UnuoVf2efulQO7x9jOqzYjxJTmeVH9rFFL77kIsxiTkw4I9zirzMa5L8aDA39X9RXPgcB7pZWCUwmmdUFh0Cgx959jSkgilVEcoqlqpBvoO3EXrJqF0ReJvgoxzlHMtx1eZwFX68-ZHQG8BGeWnMZwi6gHQro5h-mq1Xj2UcnVhfpr97CNdG3eBQ"),
            exceptionHandler
        )
    ).build()
}