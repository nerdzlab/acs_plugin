package com.acs_plugin

import android.content.Context
import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.CallCompositeBuilder
import com.acs_plugin.calling.models.CallCompositeGroupCallLocator
import com.acs_plugin.calling.models.CallCompositeJoinLocator
import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.communication.common.CommunicationTokenRefreshOptions
import com.azure.android.communication.common.CommunicationUserIdentifier

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.UUID

/** AcsPlugin */
class AcsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext

    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "acs_plugin")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      "initializeRoom" -> {
        val args = call.arguments as? Map<*, *>
        val token = args?.get("token") as? String
        val roomId = args?.get("roomId") as? String
        val userId = args?.get("userId") as? String

        if (token != null && roomId != null && userId != null) {
          initializeRoomCall(token, roomId, userId)
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

  private fun initializeRoomCall(token: String, roomId: String, userId: String) {
    val communicationTokenRefreshOptions = CommunicationTokenRefreshOptions({ token }, true)
    val communicationTokenCredential = CommunicationTokenCredential(communicationTokenRefreshOptions)

    val locator: CallCompositeJoinLocator = CallCompositeGroupCallLocator(UUID.fromString(roomId))
    val callComposite: CallComposite = CallCompositeBuilder()
      .applicationContext(this.context)
      .credential(communicationTokenCredential)
      .displayName("DG")
      .userId(CommunicationUserIdentifier(userId))
      .build()

    callComposite.launch(this.context, locator)
  }
}
