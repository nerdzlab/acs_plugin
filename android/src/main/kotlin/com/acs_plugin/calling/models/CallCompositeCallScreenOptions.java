// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

/**
 * Options for the CallCompositeCallScreen.
 */
public final class CallCompositeCallScreenOptions {
    private CallCompositeCallScreenControlBarOptions controlBarOptions;
    private CallCompositeCallScreenHeaderViewData headerViewData;
    /**
     * Creates a CallCompositeCallScreenOptions object.
     */
    public CallCompositeCallScreenOptions() {
    }

    /**
     * Set the control bar options.
     * @param controlBarOptions The control bar options.
     * @return The {@link CallCompositeCallScreenOptions} object itself.
     */
    public CallCompositeCallScreenOptions setControlBarOptions(
            final CallCompositeCallScreenControlBarOptions controlBarOptions) {
        this.controlBarOptions = controlBarOptions;
        return this;
    }

    /**
     * Get the control bar options.
     * @return {@link CallCompositeCallScreenControlBarOptions}.
     */
    public CallCompositeCallScreenControlBarOptions getControlBarOptions() {
        return controlBarOptions;
    }
    /**
     * Set the header options.
     * @param headerViewData The header options.
     * @return The {@link CallCompositeCallScreenOptions} object itself.
     */
    public CallCompositeCallScreenOptions setHeaderViewData(
            final CallCompositeCallScreenHeaderViewData headerViewData) {
        this.headerViewData = headerViewData;
        return this;
    }

    /**
     * Get the header view data.
     * @return {@link CallCompositeCallScreenHeaderViewData}.
     */
    public CallCompositeCallScreenHeaderViewData getHeaderViewData() {
        return headerViewData;
    }
}
