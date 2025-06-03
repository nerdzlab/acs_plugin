package com.acs_plugin.extension

import android.widget.TextView
import androidx.annotation.ColorRes

fun TextView.setTextColorResource(@ColorRes colorResId: Int) {
    setTextColor(resources.getColor(colorResId, null))
}