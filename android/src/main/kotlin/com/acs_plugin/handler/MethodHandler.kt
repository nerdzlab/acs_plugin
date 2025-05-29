package com.acs_plugin.handler

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

interface MethodHandler {
    fun handle(call: MethodCall, result: MethodChannel.Result): Boolean
}