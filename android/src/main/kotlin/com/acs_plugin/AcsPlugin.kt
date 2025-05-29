package com.acs_plugin

import android.app.Activity
import android.content.Context
import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.CallCompositeBuilder
import com.acs_plugin.calling.models.CallCompositeJoinLocator
import com.acs_plugin.calling.models.CallCompositeRoomLocator
import com.acs_plugin.handler.MethodHandler
import com.acs_plugin.handler.UserDataHandler
import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.communication.common.CommunicationTokenRefreshOptions
import com.azure.android.communication.common.CommunicationUserIdentifier

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
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

    private var activity: Activity? = null
    private lateinit var context: Context

    private val handlers = mutableListOf<MethodHandler>()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "acs_plugin")
        channel.setMethodCallHandler(this)
        setupHandlers()
    }


    // ActivityAware callbacks:
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
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
        handlers.forEach { handler -> handler.handle(call, result) }
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "initializeRoomCall" -> {
                val args = call.arguments as? Map<*, *>
                val token = args?.get("token") as? String
                val roomId = args?.get("roomId") as? String
                val userId = args?.get("userId") as? String

                if (token != null && roomId != null && userId != null) {
                    initializeRoomCall(token, roomId, userId, result)
                } else {
                    result.error(
                        "INVALID_ARGUMENTS",
                        "Token, roomId and userId are required",
                        null
                    )
                }
            }

            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun initializeRoomCall(token: String, roomId: String, userId: String, result: MethodChannel.Result) {
        if (activity == null) {
            result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
            return
        }

        val communicationTokenRefreshOptions = CommunicationTokenRefreshOptions({ token }, true)
        val communicationTokenCredential = CommunicationTokenCredential(communicationTokenRefreshOptions)

        val locator: CallCompositeJoinLocator = CallCompositeRoomLocator(roomId)
        val callComposite: CallComposite = CallCompositeBuilder()
            .applicationContext(this.context)
            .credential(communicationTokenCredential)
            .displayName("DG")
            .userId(CommunicationUserIdentifier(userId))
            .build()

        callComposite.launch(this.activity, locator)
        result.success(null)
    }

    private fun setupHandlers() {
        handlers.add(UserDataHandler(context, channel) { userData ->

        })
    }
}
