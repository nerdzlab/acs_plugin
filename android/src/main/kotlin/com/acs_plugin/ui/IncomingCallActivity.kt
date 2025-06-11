package com.acs_plugin.ui

import android.content.Intent
import android.os.Bundle
import android.view.WindowManager
import android.widget.ImageButton
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.NotificationManagerCompat
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.acs_plugin.consts.PluginConstants
import com.acs_plugin.R
import com.acs_plugin.data.enum.OneOnOneCallingAction

class IncomingCallActivity : AppCompatActivity() {

    companion object {
        const val DISPLAY_NAME = "DisplayName"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_incoming_call)

        val notificationManager = NotificationManagerCompat.from(this)
        notificationManager.cancel(1)

        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                    or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                    or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        )

        intent.getStringExtra("DISPLAY_NAME")?.let {
             findViewById<TextView>(R.id.profile_name).text = it
        }

        findViewById<ImageButton>(R.id.accept).setOnClickListener {
            val intent = Intent("acs_chat_intent")
            intent.putExtra(PluginConstants.Arguments.ACTION_TYPE, OneOnOneCallingAction.ACCEPT)
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
            finish()
        }
        findViewById<ImageButton>(R.id.decline).setOnClickListener {
            val intent = Intent("acs_chat_intent")
            intent.putExtra(PluginConstants.Arguments.ACTION_TYPE, OneOnOneCallingAction.DECLINE)
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
            finish()
        }
        supportActionBar?.hide()
    }
}