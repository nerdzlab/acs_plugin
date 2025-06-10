package com.acs_plugin

import android.os.Bundle
import android.view.WindowManager
import android.widget.ImageButton
import androidx.appcompat.app.AppCompatActivity

class IncomingCallActivity : AppCompatActivity() {

    companion object {
        const val DISPLAY_NAME = "DisplayName"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_incoming_call)
        window.addFlags(
            WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED
                    or WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON
                    or WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
        )
        val context = this
            findViewById<ImageButton>(R.id.accept).setOnClickListener {
//                val application = application as CallLauncherApplication
//                val acsIdentityToken = sharedPreference.getString(CACHED_TOKEN, "")
//                val displayName = sharedPreference.getString(CACHED_USER_NAME, "")
//                application.getCallCompositeManager(context).acceptIncomingCall(this@IncomingCallActivity, acsIdentityToken!!, displayName!!)
//                finish()
            }
        findViewById<ImageButton>(R.id.decline).setOnClickListener {
//                val application = application as CallLauncherApplication
//                application.getCallCompositeManager(context).declineIncomingCall()
//                finish()
            }

            intent.getStringExtra(DISPLAY_NAME)?.let {
//                profileName.text = it
            }

        supportActionBar?.hide()
    }
}