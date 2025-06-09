package com.example.acs_plugin_example

import com.acs_plugin.utils.FlutterEventDispatcher
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "acs_plugin_events").setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    FlutterEventDispatcher.setEventSink(events)
                }

                override fun onCancel(arguments: Any?) {
                    FlutterEventDispatcher.clear()
                }
            }
        )
    }
}
