package com.acs_plugin.utils

import io.flutter.plugin.common.EventChannel

object FlutterEventDispatcher {

    private var eventSink: EventChannel.EventSink? = null

    fun setEventSink(sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    fun clear() {
        eventSink = null
    }

    fun sendEvent(event: String, payload: Any? = null) {
        val eventMap = mutableMapOf<String, Any>("event" to event)
        payload?.let { eventMap["payload"] = it }
        eventSink?.success(eventMap)
    }
}