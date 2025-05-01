// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package android.src.main.kotlin.com.acs_plugin.calling.models;

import com.azure.android.communication.ui.calling.CallComposite;

import java.util.UUID;

/**
 * Group Call locator to start group call experience using {@link CallComposite}.
 */
public final class CallCompositeGroupCallLocator extends CallCompositeJoinLocator {

    private final UUID groupId;

    /**
     * Creates {@link CallCompositeGroupCallLocator}.
     * @param groupId   Group call identifier.
     */
    public CallCompositeGroupCallLocator(final UUID groupId) {
        this.groupId = groupId;
    }

    /**
     * Get group call id.
     *
     * @return {@link UUID}
     */
    public UUID getGroupId() {
        return groupId;
    }
}
