package com.acs_plugin.utils

import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

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

        CoroutineScope(Dispatchers.Main).launch {
            eventSink?.success(eventMap)
        }
    }
}