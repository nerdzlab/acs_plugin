// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

/**
 * Event with call state.
 */
public final class CallCompositeCallStateChangedEvent {
    private final CallCompositeCallStateCode code;
    private final String callId;
    private final int callEndReasonCode;
    private final int callEndReasonSubCode;

    /**
     * Create {@link CallCompositeCallStateChangedEvent} with call state.
     *
     * @param code call state {@link CallCompositeCallStateCode}.
     */
    public CallCompositeCallStateChangedEvent(final CallCompositeCallStateCode code) {
        this.code = code;
        this.callEndReasonCode = 0;
        this.callEndReasonSubCode = 0;
        this.callId = "";
    }

    CallCompositeCallStateChangedEvent(final CallCompositeCallStateCode code,
                                              final int callEndReasonCode,
                                              final int callEndReasonSubCode,
                                              final String callId) {
        this.code = code;
        this.callEndReasonCode = callEndReasonCode;
        this.callEndReasonSubCode = callEndReasonSubCode;
        this.callId = callId;
    }

    /**
     * Returns the call state.
     *
     * @return the call state {@link CallCompositeCallStateCode} instance.
     */
    public CallCompositeCallStateCode getCode() {
        return code;
    }

    /**
     * Returns the call end reason code.
     *
     * @return the call end reason code.
     */
    public Integer getCallEndReasonCode() {
        return callEndReasonCode;
    }

    /**
     * Returns the call end reason sub code.
     *
     * @return the call end reason sub code.
     */
    public Integer getCallEndReasonSubCode() {
        return callEndReasonSubCode;
    }

    /**
     * Returns the call id.
     *
     * @return the call id.
     */
    public String getCallId() {
        return callId;
    }
}
