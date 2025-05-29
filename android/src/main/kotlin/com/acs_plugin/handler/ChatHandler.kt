package com.acs_plugin.handler

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class ChatHandler(
    private val context: Context,
    private val channel: MethodChannel
) : MethodHandler {

    override fun handle(
        call: MethodCall,
        result: MethodChannel.Result
    ): Boolean {
        return false
    }
}