// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.configuration.events

import com.acs_plugin.calling.CallCompositeEventHandler
import com.acs_plugin.calling.models.CallCompositeCallStateChangedEvent
import com.acs_plugin.calling.models.CallCompositeErrorEvent
import com.acs_plugin.calling.models.CallCompositePictureInPictureChangedEvent
import com.acs_plugin.calling.models.CallCompositeDismissedEvent
import com.acs_plugin.calling.models.CallCompositeRemoteParticipantJoinedEvent
import com.acs_plugin.calling.models.CallCompositeUserReportedIssueEvent
import com.acs_plugin.calling.models.CallCompositeAudioSelectionChangedEvent
import com.acs_plugin.calling.models.CallCompositeIncomingCallCancelledEvent
import com.acs_plugin.calling.models.CallCompositeIncomingCallEvent
import com.acs_plugin.calling.models.CallCompositeRemoteParticipantLeftEvent
/*  <CALL_START_TIME>
import java.util.Date
</CALL_START_TIME> */

internal class CallCompositeEventsHandler {
    // mutableSet does preserve element iteration order
    private val errorHandlers = mutableSetOf<CallCompositeEventHandler<CallCompositeErrorEvent>>()
    private val remoteParticipantJoinedHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeRemoteParticipantJoinedEvent>>()

    private val remoteParticipantRemovedHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeRemoteParticipantLeftEvent>>()

    private val callStateHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeCallStateChangedEvent>>()
    private val exitEventHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeDismissedEvent>>()
    private val userReportHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeUserReportedIssueEvent>>()
    private val multitaskingStateChangedEvent =
        mutableSetOf<CallCompositeEventHandler<CallCompositePictureInPictureChangedEvent>>()

    private val audioSelectionChangedEventHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeAudioSelectionChangedEvent>>()

    private val incomingCallEventHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeIncomingCallEvent>>()

    private val incomingCallCancelledEventHandlers =
        mutableSetOf<CallCompositeEventHandler<CallCompositeIncomingCallCancelledEvent>>()

    /*  <CALL_START_TIME>
    private val callStartTimeUpdatedEventHandlers =
        mutableSetOf<CallCompositeEventHandler<Date>>()
    </CALL_START_TIME> */

    fun getOnErrorHandlers() = errorHandlers.asIterable()

    fun addOnErrorEventHandler(errorHandler: CallCompositeEventHandler<CallCompositeErrorEvent>) =
        errorHandlers.add(errorHandler)

    fun removeOnErrorEventHandler(errorHandler: CallCompositeEventHandler<CallCompositeErrorEvent>) =
        errorHandlers.remove(errorHandler)

    fun getOnRemoteParticipantJoinedHandlers() = remoteParticipantJoinedHandlers.asIterable()

    fun addOnRemoteParticipantJoinedEventHandler(handler: CallCompositeEventHandler<CallCompositeRemoteParticipantJoinedEvent>) =
        remoteParticipantJoinedHandlers.add(handler)

    fun removeOnRemoteParticipantJoinedEventHandler(handler: CallCompositeEventHandler<CallCompositeRemoteParticipantJoinedEvent>) =
        remoteParticipantJoinedHandlers.remove(handler)
    fun getOnRemoteParticipantRemovedHandlers() = remoteParticipantRemovedHandlers.asIterable()

    fun addOnRemoteParticipantLeftEventHandler(handler: CallCompositeEventHandler<CallCompositeRemoteParticipantLeftEvent>) =
        remoteParticipantRemovedHandlers.add(handler)

    fun removeOnRemoteParticipantLeftEventHandler(handler: CallCompositeEventHandler<CallCompositeRemoteParticipantLeftEvent>) =
        remoteParticipantRemovedHandlers.remove(handler)
    fun getOnAudioSelectionChangedEventHandlers() = audioSelectionChangedEventHandlers.asIterable()

    fun getOnMultitaskingStateChangedEventHandlers() = multitaskingStateChangedEvent.asIterable()
    fun addOnMultitaskingStateChangedEventHandler(handler: CallCompositeEventHandler<CallCompositePictureInPictureChangedEvent>) =
        multitaskingStateChangedEvent.add(handler)

    fun removeOnMultitaskingStateChangedEventHandler(handler: CallCompositeEventHandler<CallCompositePictureInPictureChangedEvent>) =
        multitaskingStateChangedEvent.remove(handler)

    fun getCallStateHandler() = callStateHandlers.asIterable()

    fun removeOnCallStateEventHandler(eventHandler: CallCompositeEventHandler<CallCompositeCallStateChangedEvent>) =
        callStateHandlers.remove(eventHandler)

    fun addOnCallStateChangedEventHandler(eventHandler: CallCompositeEventHandler<CallCompositeCallStateChangedEvent>) =
        callStateHandlers.add(eventHandler)

    fun getOnExitEventHandlers() = exitEventHandlers.asIterable()

    fun addOnDismissedEventHandler(handler: CallCompositeEventHandler<CallCompositeDismissedEvent>) {
        exitEventHandlers.add(handler)
    }

    fun removeOnExitEventHandler(handler: CallCompositeEventHandler<CallCompositeDismissedEvent>) {
        exitEventHandlers.remove(handler)
    }

    fun addOnUserReportedEventHandler(errorHandler: CallCompositeEventHandler<CallCompositeUserReportedIssueEvent>) =
        userReportHandlers.add(errorHandler)

    fun removeOnUserReportedEventHandler(errorHandler: CallCompositeEventHandler<CallCompositeUserReportedIssueEvent>) =
        userReportHandlers.remove(errorHandler)

    fun getOnUserReportedHandlers() = userReportHandlers.asIterable()
    fun addOnAudioSelectionChangedEventHandler(eventHandler: CallCompositeEventHandler<CallCompositeAudioSelectionChangedEvent>) {
        audioSelectionChangedEventHandlers.add(eventHandler)
    }

    fun removeOnAudioSelectionChangedEventHandler(eventHandler: CallCompositeEventHandler<CallCompositeAudioSelectionChangedEvent>) {
        audioSelectionChangedEventHandlers.remove(eventHandler)
    }

    fun addOnIncomingCallCancelledEventHandler(handler: CallCompositeEventHandler<CallCompositeIncomingCallCancelledEvent>) {
        incomingCallCancelledEventHandlers.add(handler)
    }

    fun removeOnIncomingCallCancelledEventHandler(handler: CallCompositeEventHandler<CallCompositeIncomingCallCancelledEvent>) {
        incomingCallCancelledEventHandlers.remove(handler)
    }

    fun getOnIncomingCallCancelledHandlers() = incomingCallCancelledEventHandlers.asIterable()

    fun addOnIncomingCallEventHandler(handler: CallCompositeEventHandler<CallCompositeIncomingCallEvent>) {
        incomingCallEventHandlers.add(handler)
    }

    fun removeOnIncomingCallEventHandler(handler: CallCompositeEventHandler<CallCompositeIncomingCallEvent>) {
        incomingCallEventHandlers.remove(handler)
    }

    fun getOnIncomingCallHandlers() = incomingCallEventHandlers.asIterable()

    /*  <CALL_START_TIME>
    fun getOnCallStartTimeUpdatedHandlers() = callStartTimeUpdatedEventHandlers.asIterable()

    fun addOnCallStartTimeUpdatedEventHandler(eventHandler: CallCompositeEventHandler<Date>) {
        callStartTimeUpdatedEventHandlers.add(eventHandler)
    }

    fun removeOnCallStartTimeUpdatedEventHandler(eventHandler: CallCompositeEventHandler<Date>) {
        callStartTimeUpdatedEventHandlers.remove(eventHandler)
    }
    </CALL_START_TIME> */
}
