// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.menu

import com.acs_plugin.calling.models.ParticipantCapabilityType
import com.acs_plugin.calling.presentation.manager.CapabilitiesManager
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.ParticipantAction
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

internal class ParticipantMenuViewModel(
    private val dispatch: (Action) -> Unit,
    private val capabilitiesManager: CapabilitiesManager,
) {
    private val displayMenuStateFlow = MutableStateFlow(false)
    private var userIdentifier: String? = null
    private val muteParticipantEnabledMutableFlow = MutableStateFlow(false)
    private val remoteParticipantEnabledMutableFlow = MutableStateFlow(false)

    val displayMenuFlow = displayMenuStateFlow.asStateFlow()
    var displayName: String? = null
    val muteParticipantEnabledFlow = muteParticipantEnabledMutableFlow.asStateFlow()
    val remoteParticipantEnabledFlow = remoteParticipantEnabledMutableFlow.asStateFlow()

    fun init(capabilities: Set<ParticipantCapabilityType>) {
        update(capabilities)
    }

    fun update(capabilities: Set<ParticipantCapabilityType>) {
        remoteParticipantEnabledMutableFlow.value = capabilitiesManager.hasCapability(
            capabilities,
            ParticipantCapabilityType.REMOVE_PARTICIPANT,
        )
    }

    fun displayParticipantMenu(
        userIdentifier: String,
        displayName: String?
    ) {
        this.userIdentifier = userIdentifier
        this.displayName = displayName
        displayMenuStateFlow.value = true
    }

    fun close() {
        displayMenuStateFlow.value = false
    }

    fun muteParticipant() {
        close()
    }

    fun removeParticipant() {
        userIdentifier?.let {
            dispatch(ParticipantAction.Remove(it))
        }
        close()
    }
}
