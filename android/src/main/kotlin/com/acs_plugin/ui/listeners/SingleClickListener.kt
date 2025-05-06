package com.acs_plugin.ui.listeners

import android.os.SystemClock
import android.view.View

/**
 * Click listener class which is to prevent double quick clicking of a view
 */
class SingleClickListener(private val onClickAction: (View) -> Unit) : View.OnClickListener {

    private var interval: Int = 1000
    private var lastTimeClicked: Long = 0

    override fun onClick(view: View?) {
        if (SystemClock.elapsedRealtime() - lastTimeClicked < interval) {
            return
        }
        lastTimeClicked = SystemClock.elapsedRealtime()
        view?.let { onClickAction(it) }
    }

}