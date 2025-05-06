package com.acs_plugin.extension

import android.annotation.SuppressLint
import android.view.MotionEvent
import android.view.View
import com.acs_plugin.ui.listeners.SingleClickListener

private const val DEFAULT_SCALE_FACTOR = 1f
private const val CLICK_SCALE_FACTOR = 0.95f
private const val SCALE_ANIMATION_DURATION_IN_MILLIS = 50L

fun View.onSingleClickListener(shouldAddScaleAnimation: Boolean = true, onClick: (View) -> Unit) {
    setOnClickListener(SingleClickListener { onClick(it) })
    if (shouldAddScaleAnimation) addTouchableScaleEffect()
}

@SuppressLint("ClickableViewAccessibility")
fun View.addTouchableScaleEffect() {
    setOnTouchListener { v, event ->
        return@setOnTouchListener when (event.action) {
            MotionEvent.ACTION_DOWN -> {
                v.animateScale(CLICK_SCALE_FACTOR, SCALE_ANIMATION_DURATION_IN_MILLIS)
                false // Return false to continue processing click events
            }

            MotionEvent.ACTION_UP, MotionEvent.ACTION_CANCEL -> {
                v.animateScale(DEFAULT_SCALE_FACTOR, SCALE_ANIMATION_DURATION_IN_MILLIS)
                false // Return false so that the click event is still triggered
            }

            else -> false
        }
    }
}

private fun View.animateScale(scaleFactor: Float, duration: Long) {
    postDelayed({
        animate()
            .scaleX(scaleFactor)
            .scaleY(scaleFactor)
            .setDuration(duration)
            .start()
    }, duration)
}