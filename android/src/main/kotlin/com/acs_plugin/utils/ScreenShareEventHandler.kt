package com.acs_plugin.utils

import android.content.Intent
import java.util.concurrent.CompletableFuture

interface ScreenShareEventHandler {
    fun onMediaProjectionResult(requestCode: Int, resultCode: Int, data: Intent?)
}

internal class ScreenShareEventHandlerImpl : ScreenShareEventHandler {
    private var pendingScreenShareFuture: CompletableFuture<Pair<Int, Intent?>>? = null

    fun requestMediaProjectionPermission(): CompletableFuture<Pair<Int, Intent?>> {
        pendingScreenShareFuture = CompletableFuture()
        return pendingScreenShareFuture!!
    }

    override fun onMediaProjectionResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_MEDIA_PROJECTION) {
            pendingScreenShareFuture?.complete(Pair(resultCode, data))
            pendingScreenShareFuture = null
        }
    }

    companion object {
        const val REQUEST_MEDIA_PROJECTION = 1001
    }
}