package com.acs_plugin

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Parcelable
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.acs_plugin.handler.CallHandler
import com.acs_plugin.handler.ChatHandler
import com.acs_plugin.handler.MethodHandler
import com.acs_plugin.handler.UserDataHandler
import com.acs_plugin.utils.CallCompositeManager
import com.acs_plugin.utils.FlutterEventDispatcher
import com.acs_plugin.utils.SettingsFeatures
import com.google.firebase.messaging.RemoteMessage
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** AcsPlugin */
class AcsPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel

    private var activity: Activity? = null
    private lateinit var context: Context

    private val handlers = mutableListOf<MethodHandler>()

    private var callCompositeManager: CallCompositeManager? = null

    fun getCallCompositeManager(context: Context): CallCompositeManager {
        if (callCompositeManager == null) {
            callCompositeManager = CallCompositeManager(context)
        }
        return callCompositeManager!!
    }

    val firebaseMessagingReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {
            val pushNotification =
                intent.getParcelableExtra<Parcelable?>("PushNotificationPayload") as RemoteMessage

            Log.d("BroadcastReceiver", "Push Notification received in MainActivity: " + pushNotification.data)

            val userData = (handlers.firstOrNull { it is UserDataHandler } as UserDataHandler).userDataClass

            getCallCompositeManager(this@AcsPlugin.context).handleIncomingCall(
                value = pushNotification.data,
                acsIdentityToken = userData?.token.orEmpty(),
                displayName = userData?.name.orEmpty(),
                this@AcsPlugin.context
            )
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "acs_plugin")
        channel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "acs_plugin_events")
    }

    // ActivityAware callbacks:
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        SettingsFeatures.initialize(context)
        setupHandlers()
        LocalBroadcastManager
            .getInstance(activity!!)
            .registerReceiver(
                firebaseMessagingReceiver,
                IntentFilter("acs_chat_intent")
            )
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == Constants.MethodChannels.GET_PRELOADED_ACTION) return
        handlers.forEach { handler -> handler.handle(call, result) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setupHandlers() {
        val userDataHandler = UserDataHandler(context, channel) {
            getCallCompositeManager(context).registerPush(context, it.token, it.name)
            handlers.forEach { it.onUserReceived() }
        }
        val callHandler = CallHandler(context, activity)
        val chatHandler = ChatHandler(context) {
            FlutterEventDispatcher.sendEvent(it.name, it.payload)
        }
        handlers.addAll(
            listOf(
                userDataHandler,
                callHandler,
                chatHandler
            )
        )
    }
}
