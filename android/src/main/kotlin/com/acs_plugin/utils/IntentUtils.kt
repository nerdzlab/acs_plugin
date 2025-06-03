package com.acs_plugin.utils

import android.app.Activity
import android.content.Intent

object IntentUtils {

    fun shareText(activity: Activity, text: String) {
        val intent = Intent(Intent.ACTION_SEND).apply {
            type = "text/plain"
            putExtra(Intent.EXTRA_TEXT, text)
        }
        activity.startActivity(Intent.createChooser(intent, ""))
    }
}