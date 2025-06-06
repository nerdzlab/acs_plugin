package com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data

import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import com.acs_plugin.R

enum class ParticipantMenuType(
    @StringRes val titleResId: Int,
    @DrawableRes val iconResId: Int
) {
    PIN(R.string.pin_for_me, R.drawable.ic_pin),
    UNPIN(R.string.unpin, R.drawable.ic_unpin),
    HIDE_VIDEO(R.string.do_not_show_video, R.drawable.ic_camera_off),
    SHOW_VIDEO(R.string.show_video, R.drawable.ic_camera);

    fun mapToParticipantMenuItem(): ParticipantMenuItem {
        return ParticipantMenuItem(
            id = ordinal,
            type = this,
            titleResId = titleResId,
            iconResId = iconResId
        )
    }
}