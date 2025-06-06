package com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data

data class ParticipantMenuItem(
    val id: Int,
    val type: ParticipantMenuType,
    val titleResId: Int,
    val iconResId: Int,
    var isEnabled: Boolean = true
)
