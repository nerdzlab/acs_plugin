package com.acs_plugin.calling.presentation.fragment.calling.moreactions.data

import androidx.annotation.StringRes
import com.acs_plugin.R

enum class ReactionType(@StringRes val titleResId: Int, val serverKey: String) {
    LIKE(R.string.emoji_like, ":+1:"),
    HEART(R.string.emoji_heart, ":heart:"),
    APPLAUSE(R.string.emoji_applause, ":clap:"),
    LAUGH(R.string.emoji_laugh, ":laughing:"),
    SURPRISED(R.string.emoji_surprised, ":astonished:");

    companion object {
        fun fromServerKey(value: String): ReactionType? {
            return entries.firstOrNull { it.serverKey == value }
        }
    }
}