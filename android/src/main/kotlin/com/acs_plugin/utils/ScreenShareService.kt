package com.acs_plugin.utils

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.Image
import android.media.ImageReader
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Handler
import android.os.HandlerThread
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.azure.android.communication.calling.*
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.util.concurrent.atomic.AtomicBoolean

class ScreenShareService : Service() {

    private var mediaProjectionManager: MediaProjectionManager? = null
    private var mediaProjection: MediaProjection? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var imageReader: ImageReader? = null
    private var handler: Handler? = null
    private var handlerThread: HandlerThread? = null
    private var w = 0
    private var h = 0
    private var frameRate = 30

//    private var screenShareOutgoingVideoStream: ScreenShareOutgoingVideoStream? = null
    private var videoStreamFormat: VideoStreamFormat? = null
    private var call: Call? = null

    private val isProcessingFrame = AtomicBoolean(false)
    private val isServiceRunning = AtomicBoolean(false)

    private val NOTIFICATION_CHANNEL_ID = "ScreenShareServiceChannel"
    private val NOTIFICATION_ID = 1

    companion object {
        const val ACTION_START_SCREEN_SHARE = "ACTION_START_SCREEN_SHARE"
        const val ACTION_STOP_SCREEN_SHARE = "ACTION_STOP_SCREEN_SHARE"
        const val EXTRA_RESULT_CODE = "EXTRA_RESULT_CODE"
        const val EXTRA_RESULT_DATA = "EXTRA_RESULT_DATA"
        const val EXTRA_WIDTH = "EXTRA_WIDTH"
        const val EXTRA_HEIGHT = "EXTRA_HEIGHT"
        const val EXTRA_FRAME_RATE = "EXTRA_FRAME_RATE"

        private const val TAG = "ScreenShareService"

        // Static reference to pass the call instance
        var activeCall: Call? = null
        var screenShareOutgoingVideoStream: ScreenShareOutgoingVideoStream? = null
    }

    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, "Service onCreate")
        createNotificationChannel()
        startForeground(NOTIFICATION_ID, createNotification())
        mediaProjectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager

        handlerThread = HandlerThread("ScreenShareThread").apply { start() }
        handler = Handler(handlerThread!!.looper)
        isServiceRunning.set(true)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, "Service started with action: ${intent?.action}")

        when (intent?.action) {
            ACTION_START_SCREEN_SHARE -> {
                val resultCode = intent.getIntExtra(EXTRA_RESULT_CODE, 0)
                val resultData = intent.getParcelableExtra<Intent>(EXTRA_RESULT_DATA)
                w = intent.getIntExtra(EXTRA_WIDTH, 0)
                h = intent.getIntExtra(EXTRA_HEIGHT, 0)
                frameRate = intent.getIntExtra(EXTRA_FRAME_RATE, frameRate)
                call = activeCall

                Log.d(TAG, "Starting screen capture with dimensions: $w x $h at $frameRate FPS")

                if (resultCode != 0 && resultData != null && call != null) {
                    handler?.post {
                        if (isServiceRunning.get()) {
                            startScreenSharing(resultCode, resultData)
                        }
                    }
                } else {
                    Log.e(TAG, "Missing MediaProjection result data or active call.")
                    stopSelf()
                }
            }

            ACTION_STOP_SCREEN_SHARE -> {
                handler?.post {
                    stopScreenSharing()
                    stopSelf()
                }
            }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        Log.d(TAG, "Service onDestroy")
        isServiceRunning.set(false)
        stopScreenSharing()

        handler?.removeCallbacksAndMessages(null)
        handlerThread?.quitSafely()

        try {
            handlerThread?.join(2000) // Wait max 2 seconds
        } catch (e: InterruptedException) {
            Log.w(TAG, "Handler thread interrupted during shutdown")
        }

        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null

    private fun createNotificationChannel() {
        val serviceChannel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID,
            "Screen Share Service Channel",
            NotificationManager.IMPORTANCE_LOW
        )
        val manager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(serviceChannel)
    }

    private fun createNotification(): Notification {
        return NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
            .setContentTitle("Screen Sharing")
            .setContentText("Your screen is being shared.")
            .setSmallIcon(android.R.drawable.ic_notification_overlay)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }

    private fun startScreenSharing(resultCode: Int, resultData: Intent) {
        Log.d(TAG, "Starting screen sharing")

        try {
            if (!isServiceRunning.get() || call == null) return

            mediaProjection = mediaProjectionManager?.getMediaProjection(resultCode, resultData)
            if (mediaProjection == null) {
                Log.e(TAG, "Failed to create MediaProjection")
                stopSelf()
                return
            }

            mediaProjection?.registerCallback(MediaProjectionCallback(), handler)
            Log.d(TAG, "MediaProjection created successfully")

            // Setup Azure video stream first
            setupAzureVideoStream()

            // Use RGBA_8888 format for compatibility
            imageReader = ImageReader.newInstance(w, h, PixelFormat.RGBA_8888, 2)
            Log.d(TAG, "ImageReader created: ${w}x${h} with RGBA_8888 format")

            val densityDpi = 160

            virtualDisplay = mediaProjection?.createVirtualDisplay(
                "ScreenShare",
                w,
                h,
                densityDpi,
                DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
                imageReader?.surface,
                null,
                handler
            )

            if (virtualDisplay == null) {
                Log.e(TAG, "Failed to create VirtualDisplay")
                stopSelf()
                return
            }

            Log.d(TAG, "VirtualDisplay created successfully")

            // Set up the listener after everything is ready
            imageReader?.setOnImageAvailableListener(SafeImageAvailableListener(), handler)

            Log.d(TAG, "Screen sharing setup completed")
        } catch (e: Exception) {
            Log.e(TAG, "Exception in startScreenSharing: ${e.message}", e)
            stopSelf()
        }
    }

    private fun setupAzureVideoStream() {
        try {
            Log.d(TAG, "Setting up Azure video stream")

            // Create our own VideoStreamFormat that matches our buffer
            videoStreamFormat = VideoStreamFormat().apply {
                width = 1280
                height = 720
//                resolution = VideoStreamResolution.P360
                pixelFormat = VideoStreamPixelFormat.RGBA
                framesPerSecond = frameRate.toFloat()
                stride1 = width * 4 // 4 bytes per pixel for RGBA
            }

            val rawOutgoingVideoStreamOptions = RawOutgoingVideoStreamOptions().apply {
                formats = listOf(videoStreamFormat!!)
            }

            screenShareOutgoingVideoStream = ScreenShareOutgoingVideoStream(rawOutgoingVideoStreamOptions)

            startScreenSharingVideo()

            Log.d(TAG, "ScreenShareOutgoingVideoStream created successfully")

        } catch (e: Exception) {
            Log.e(TAG, "Failed to setup Azure video stream: ${e.message}", e)
            throw e
        }
    }

// Add this property at the top of the class

    private fun startScreenSharingVideo() {
        Log.d(TAG, "Starting screen sharing video after delay")

        if (screenShareOutgoingVideoStream == null) {
            Log.e(TAG, "Screen share video stream is null")
            handler?.post {
                stopScreenSharing()
                stopSelf()
            }
            return
        }

        if (call == null) {
            Log.e(TAG, "Call is null, cannot start video")
            handler?.post {
                stopScreenSharing()
                stopSelf()
            }
            return
        }

        // Start the video stream with the call after 5 seconds delay
        handler?.postDelayed({
            try {
                call?.startVideo(this@ScreenShareService, screenShareOutgoingVideoStream!!)
                    ?.whenComplete { _, exception ->
                        if (exception != null) {
                            Log.e(TAG, "Failed to start screen sharing video: ${exception.message}", exception)
                            handler?.post {
                                stopScreenSharing()
                                stopSelf()
                            }
                        } else {
                            Log.d(TAG, "Screen sharing video started successfully")
                        }
                    }
            } catch (e: Exception) {
                Log.e(TAG, "Exception starting screen sharing video: ${e.message}", e)
                handler?.post {
                    stopScreenSharing()
                    stopSelf()
                }
            }
        }, 5000) // 5 seconds delay
    }

    private fun stopScreenSharing() {
        Log.d(TAG, "Stopping screen sharing")

        // Immediately stop sending frames

        try {
            imageReader?.setOnImageAvailableListener(null, null)

            // Stop the specific screen share video stream
            screenShareOutgoingVideoStream?.let { stream ->
                call?.stopVideo(this@ScreenShareService, stream)?.whenComplete { _, exception ->
                    if (exception != null) {
                        Log.w(TAG, "Failed to stop screen sharing video on call: ${exception.message}")
                    }
                }
            }

            screenShareOutgoingVideoStream = null
            videoStreamFormat = null
            call = null

            virtualDisplay?.release()
            virtualDisplay = null

            imageReader?.close()
            imageReader = null

            mediaProjection?.stop()
            mediaProjection = null

            Log.d(TAG, "Screen sharing stopped successfully")
        } catch (e: Exception) {
            Log.e(TAG, "Error stopping screen sharing: ${e.message}", e)
        }
    }

    private inner class SafeImageAvailableListener : ImageReader.OnImageAvailableListener {
        override fun onImageAvailable(reader: ImageReader) {
            if (!isProcessingFrame.compareAndSet(false, true) || !isServiceRunning.get()) {
                return
            }

            var image: Image? = null
            try {
                if (screenShareOutgoingVideoStream == null || videoStreamFormat == null) {
                    Log.w(TAG, "Video stream not ready")
                    return
                }

                image = reader.acquireLatestImage()
                if (image == null) {
                    return
                }

                processImageFrame(image)

            } catch (e: Exception) {
                Log.e(TAG, "Error in frame processing: ${e.message}", e)
            } finally {
                image?.close()
                isProcessingFrame.set(false)
            }
        }

        private fun processImageFrame(image: Image) {
            try {
                // Check if frame is valid and not null
                if (image == null) {
                    Log.w(TAG, "Image frame is null, skipping")
                    return
                }

                // Check if image is closed or invalid
                if (image.width <= 0 || image.height <= 0) {
                    Log.w(TAG, "Image frame has invalid dimensions: ${image.width}x${image.height}")
                    return
                }

                // Check if video stream is active before processing frames
//                if (!isVideoStreamActive.get()) {
//                    Log.d(TAG, "Video stream not active, skipping frame")
//                    return
//                }

                if (image.planes.isEmpty()) {
                    Log.w(TAG, "Image frame has no planes, skipping")
                    return
                }

                val plane = image.planes[0]
                val buffer = plane.buffer

                // Check if buffer is valid
                if (buffer == null || !buffer.hasRemaining()) {
                    Log.w(TAG, "Image buffer is null or empty, skipping frame")
                    return
                }

                // Double-check video stream is still active and ready
                if (screenShareOutgoingVideoStream == null || videoStreamFormat == null) {
                    Log.w(TAG, "Video stream not ready or inactive")
                    return
                }

                // Create the raw video frame buffer
                val rawVideoFrameBuffer = RawVideoFrameBuffer().apply {
                    buffers = listOf(buffer)
                    streamFormat = videoStreamFormat
                }

                // Send the frame to Azure Communication Services
                Log.d(TAG, "state: ${screenShareOutgoingVideoStream?.state}")
//                if (screenShareOutgoingVideoStream?.state == VideoStreamState.STARTED) {
                    screenShareOutgoingVideoStream?.sendRawVideoFrame(rawVideoFrameBuffer)
                        ?.whenComplete { _, exception ->
                            if (exception != null) {
                                Log.e(TAG, "Failed to send frame: ${exception.message}", exception)

                                // Handle critical errors
                                if (exception is IllegalStateException ||
                                    exception.message?.contains("Unknown error") == true
                                ) {
                                    Log.e(TAG, "Critical error in video stream, marking stream as inactive")
                                    handler?.post {
                                        stopScreenSharing()
                                        stopSelf()
                                    }
                                }
                            }
                        }
//                }

            } catch (e: Exception) {
                Log.e(TAG, "Error processing image frame: ${e.message}", e)
            }
        }
    }

    private inner class MediaProjectionCallback : MediaProjection.Callback() {
        override fun onStop() {
            Log.d(TAG, "MediaProjection stopped by system")
            handler?.post {
                stopScreenSharing()
                stopSelf()
            }
        }
    }
}