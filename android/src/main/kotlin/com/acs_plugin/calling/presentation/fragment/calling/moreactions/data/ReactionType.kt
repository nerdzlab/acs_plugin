package com.acs_plugin.calling.presentation.fragment.calling.moreactions.data

import androidx.annotation.StringRes
import com.acs_plugin.R
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
enum class ReactionType(@StringRes val titleResId: Int) {
    @SerialName(":+1:")
    LIKE(R.string.emoji_like),

    @SerialName(":heart:")
    HEART(R.string.emoji_heart),

    @SerialName(":clap:")
    APPLAUSE(R.string.emoji_applause),

    @SerialName(":laughing:")
    LAUGH(R.string.emoji_laugh),

    @SerialName(":astonished:")
    SURPRISED(R.string.emoji_surprised);
}