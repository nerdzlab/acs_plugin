// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.configuration

import android.content.Context
import com.azure.android.communication.common.CommunicationIdentifier
import com.azure.android.communication.common.CommunicationTokenCredential
import com.acs_plugin.calling.configuration.events.CallCompositeEventsHandler
import com.acs_plugin.calling.models.CallCompositeCapabilitiesChangedNotificationMode
/*  <DEFAULT_AUDIO_MODE:0>
import com.acs_plugin.calling.models.CallCompositeAudioSelectionMode
</DEFAULT_AUDIO_MODE:0> */
import com.acs_plugin.calling.models.CallCompositeCallScreenOptions
import com.acs_plugin.calling.models.CallCompositeLocalOptions
import com.acs_plugin.calling.models.CallCompositeLocalizationOptions
import com.acs_plugin.calling.models.CallCompositeSetupScreenOptions
import com.acs_plugin.calling.models.CallCompositeSupportedScreenOrientation
import com.acs_plugin.calling.models.CallCompositeTelecomManagerOptions

internal class CallCompositeConfiguration {
    /*  <DEFAULT_AUDIO_MODE:0>
    var audioSelectionMode: CallCompositeAudioSelectionMode? = null
    </DEFAULT_AUDIO_MODE:0> */
    var themeConfig: Int? = null
    var localizationConfig: CallCompositeLocalizationOptions? = null
    var callCompositeEventsHandler = CallCompositeEventsHandler()
    lateinit var callConfig: CallConfiguration
    var callCompositeLocalOptions: CallCompositeLocalOptions? = null
    val remoteParticipantsConfiguration: RemoteParticipantsConfiguration = RemoteParticipantsConfiguration()
    var enableMultitasking: Boolean = false
    var enableSystemPiPWhenMultitasking: Boolean = false
    var callScreenOrientation: CallCompositeSupportedScreenOrientation? = null
    var setupScreenOrientation: CallCompositeSupportedScreenOrientation? = null
    var callScreenOptions: CallCompositeCallScreenOptions? = null
    var telecomManagerOptions: CallCompositeTelecomManagerOptions? = null
    var applicationContext: Context? = null
    var displayName: String? = null
    var credential: CommunicationTokenCredential? = null
    var disableInternalPushForIncomingCall: Boolean = false
    var capabilitiesChangedNotificationMode: CallCompositeCapabilitiesChangedNotificationMode? = null
    var setupScreenOptions: CallCompositeSetupScreenOptions? = null
    var localUserIdentifier: CommunicationIdentifier? = null
}
