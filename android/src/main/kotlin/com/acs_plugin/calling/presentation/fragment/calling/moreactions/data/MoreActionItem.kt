package com.acs_plugin.calling.presentation.fragment.calling.moreactions.data

data class MoreActionItem(
    val id: Int,
    val type: MoreActionType,
    val titleResId: Int,
    val iconResId: Int,
    var isEnabled: Boolean = true
)
