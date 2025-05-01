// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid.screenshare

import android.view.MotionEvent

internal interface GestureListenerEvents {
    fun onSingleClick()
    fun onDoubleClick(motionEvent: MotionEvent)
    fun initTransformation()
    fun updateTransformation()
}
