// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

/**
 * Event with audio selection changed.
 */
public final class CallCompositeAudioSelectionChangedEvent {
    private final CallCompositeAudioSelectionMode mode;

    /**
     * Create {@link CallCompositeAudioSelectionChangedEvent} with selection.
     *
     * @param mode selection type  {@link CallCompositeAudioSelectionMode}.
     */
    CallCompositeAudioSelectionChangedEvent(final CallCompositeAudioSelectionMode mode) {
        this.mode = mode;
    }

    /**
     * Get audio selection mode.
     *
     * @return the {@link CallCompositeAudioSelectionMode}.
     */
    public CallCompositeAudioSelectionMode getAudioSelectionMode() {
        return mode;
    }
}
