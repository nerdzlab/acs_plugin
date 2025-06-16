package com.acs_plugin.utils

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.acs_plugin.consts.PluginConstants
import com.acs_plugin.data.enum.OneOnOneCallingAction

class CallNotificationReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val actionType = intent.getSerializableExtra("ACTION_TYPE")
        when (actionType as? OneOnOneCallingAction) {
            OneOnOneCallingAction.ACCEPT -> {
                val localIntent = Intent("acs_chat_intent").apply {
                    putExtra(PluginConstants.Arguments.ACTION_TYPE, OneOnOneCallingAction.ACCEPT)
                    putExtra("CALL_ID", intent.getStringExtra("CALL_ID"))
                    putExtra("DISPLAY_NAME", intent.getStringExtra("DISPLAY_NAME"))
                }
                LocalBroadcastManager.getInstance(context).sendBroadcast(localIntent)
            }

            OneOnOneCallingAction.DECLINE -> {
                val localIntent = Intent("acs_chat_intent").apply {
                    putExtra(PluginConstants.Arguments.ACTION_TYPE, OneOnOneCallingAction.DECLINE)
                    putExtra("CALL_ID", intent.getStringExtra("CALL_ID"))
                    putExtra("DISPLAY_NAME", intent.getStringExtra("DISPLAY_NAME"))
                }
                LocalBroadcastManager.getInstance(context).sendBroadcast(localIntent)
            }

            else -> {
                Log.d("CallNotificationReceiver", "Unknown or null action type: $actionType")
            }
        }
    }
}