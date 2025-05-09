// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.service.sdk

import android.content.Context
import com.azure.android.communication.calling.CreateViewOptions
import com.azure.android.communication.calling.RemoteVideoStream

internal class VideoStreamRendererRemoteWrapper(
    private val remoteVideoStream: RemoteVideoStream,
    private val context: Context,
) : VideoStreamRenderer {
    private var videoStreamRendererView: VideoStreamRendererView? = null
    private var videoStreamRenderer: com.azure.android.communication.calling.VideoStreamRenderer? =
        null

    override fun createView(): VideoStreamRendererView? {

        videoStreamRenderer = com.azure.android.communication.calling.VideoStreamRenderer(
            remoteVideoStream,
            context,
        )

        videoStreamRendererView = videoStreamRenderer?.createView()?.into()

        return videoStreamRendererView
    }

    override fun createView(options: CreateViewOptions): VideoStreamRendererView? {
        videoStreamRenderer = com.azure.android.communication.calling.VideoStreamRenderer(
            remoteVideoStream,
            context,
        )

        videoStreamRendererView = videoStreamRenderer?.createView(options)?.into()

        return videoStreamRendererView
    }

    override fun dispose() {
        videoStreamRendererView?.dispose()
        videoStreamRenderer?.dispose()
    }

    override fun getStreamSize(): StreamSize? = videoStreamRenderer?.size?.into()
}
