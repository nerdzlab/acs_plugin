package com.acs_plugin.handler

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface MethodHandler {
    fun onFirebaseTokenReceived(token: String) {}
    fun handle(call: MethodCall, result: MethodChannel.Result): Boolean
}