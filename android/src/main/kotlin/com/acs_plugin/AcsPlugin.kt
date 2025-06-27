package com.acs_plugin

import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Parcelable
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.core.content.ContextCompat.registerReceiver
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import com.acs_plugin.consts.PluginConstants
import com.acs_plugin.data.enum.OneOnOneCallingAction
import com.acs_plugin.handler.CallHandler
import com.acs_plugin.handler.ChatHandler
import com.acs_plugin.handler.MethodHandler
import com.acs_plugin.handler.UserDataHandler
import com.acs_plugin.utils.CallNotificationReceiver
import com.acs_plugin.utils.FlutterEventDispatcher
import com.acs_plugin.utils.IncomingCallCompositeManager
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

    private var incomingCallCompositeManager: IncomingCallCompositeManager? = null

    fun getIncomingCallCompositeManager(context: Context): IncomingCallCompositeManager {
        if (incomingCallCompositeManager == null) {
            incomingCallCompositeManager = IncomingCallCompositeManager(context)
        }
        return incomingCallCompositeManager!!
    }

    val callReceiver: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent) {

            val actionType = intent.getSerializableExtra(PluginConstants.Arguments.ACTION_TYPE) as OneOnOneCallingAction?

            Log.d("BroadcastReceiver", "Push Notification received in MainActivity: " + actionType)

            val userData = (handlers.firstOrNull { it is UserDataHandler } as UserDataHandler).userDataClass

            when (actionType) {
                OneOnOneCallingAction.ACCEPT -> activity?.let { activity ->
                    getIncomingCallCompositeManager(this@AcsPlugin.context).acceptIncomingCall(
                        activity,
                        userData?.token.orEmpty(),
                        userData?.name.orEmpty()
                    )
                }

                OneOnOneCallingAction.DECLINE -> getIncomingCallCompositeManager(this@AcsPlugin.context).declineIncomingCall()
                OneOnOneCallingAction.INCOMING_CALL -> {
                    val pushNotification =
                        intent.getParcelableExtra<Parcelable?>(PluginConstants.Arguments.PUSH_NOTIFICATION_DATA) as RemoteMessage

                    getIncomingCallCompositeManager(this@AcsPlugin.context).handleIncomingCall(
                        value = pushNotification.data,
                        acsIdentityToken = userData?.token.orEmpty(),
                        displayName = userData?.name.orEmpty(),
                        this@AcsPlugin.context
                    )
                }
                else -> Unit
            }

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
        setupHandlers()
        LocalBroadcastManager
            .getInstance(activity!!)
            .registerReceiver(
                callReceiver,
                IntentFilter("acs_chat_intent")
            )

        // In your Application class or main activity onCreate
        val callNotificationReceiver = CallNotificationReceiver()
        val intentFilter = IntentFilter("com.acs_plugin.CALL_ACTION")
        registerReceiver(context, callNotificationReceiver, intentFilter, ContextCompat.RECEIVER_NOT_EXPORTED)
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
        if (call.method == PluginConstants.MethodChannels.GET_PRELOADED_ACTION) return
        handlers.forEach { handler -> handler.handle(call, result) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun setupHandlers() {
        val userDataHandler = UserDataHandler(context) {
            getIncomingCallCompositeManager(context).registerPush(context, it.token, it.name)
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
