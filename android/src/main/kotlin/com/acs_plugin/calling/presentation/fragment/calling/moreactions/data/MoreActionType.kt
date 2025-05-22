package com.acs_plugin.calling.presentation.fragment.calling.moreactions.data

import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import com.acs_plugin.R

enum class MoreActionType(
    @StringRes val titleResId: Int,
    @DrawableRes val iconResId: Int
) {
    CHAT(R.string.chat, R.drawable.ic_chat),
    PARTICIPANTS(R.string.participants, R.drawable.ic_participant),
    BLUR_ON(R.string.turn_blur_on, R.drawable.ic_blur),
    BLUR_OFF(R.string.turn_blur_off, R.drawable.ic_blur_off),
    RAISE_HAND(R.string.raise_hand, R.drawable.ic_raise_hand),
    LOWER_HAND(R.string.lower_hand, R.drawable.ic_raised_hand),
    CHANGE_VIEW(R.string.change_view, R.drawable.ic_grid_view),
    SHARE_SCREEN(R.string.share_screen, R.drawable.ic_share);

    fun mapToMoreActionItem(): MoreActionItem {
        return MoreActionItem(
            id = ordinal,
            type = this,
            titleResId = titleResId,
            iconResId = iconResId
        )
    }
}