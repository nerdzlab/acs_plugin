// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.factories

import android.content.Context
import android.media.AudioManager
import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.presentation.fragment.common.audiodevicelist.AudioDeviceListViewModel
import com.acs_plugin.calling.presentation.fragment.setup.components.JoinCallButtonHolderViewModel
import com.acs_plugin.calling.presentation.fragment.setup.components.PreviewAreaViewModel
import com.acs_plugin.calling.presentation.fragment.setup.components.SetupControlBarViewModel
import com.acs_plugin.calling.presentation.fragment.setup.components.SetupParticipantAvatarViewModel
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.state.ReduxState

internal class SetupViewModelFactory(
    private val store: Store<ReduxState>,
    private val context: Context,
    private val callType: CallType? = null,
    private val isTelecomManagerEnabled: Boolean = false,
    private val logger: Logger,
) : BaseViewModelFactory(store) {

    val audioDeviceListViewModel by lazy {
        AudioDeviceListViewModel(store::dispatch)
    }

    val previewAreaViewModel by lazy {
        PreviewAreaViewModel(store::dispatch)
    }

    val setupControlBarViewModel by lazy {
        SetupControlBarViewModel(
            store::dispatch,
            logger,
        )
    }

    val participantAvatarViewModel by lazy {
        SetupParticipantAvatarViewModel()
    }

    val joinCallButtonHolderViewModel by lazy {
        JoinCallButtonHolderViewModel(
            store::dispatch,
            context.getSystemService(Context.AUDIO_SERVICE) as AudioManager,
            callType,
            isTelecomManagerEnabled
        )
    }
}
