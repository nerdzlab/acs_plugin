// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

import com.azure.android.core.util.ExpandableStringEnum;

import java.util.Collection;

/**
 * CallCompositeTelecomManagerIntegrationMode {@link CallCompositeTelecomManagerIntegrationMode}.
 */
public final class CallCompositeTelecomManagerIntegrationMode
        extends ExpandableStringEnum<CallCompositeTelecomManagerIntegrationMode> {

    /**
     * Use telecom manager provided by native calling sdk.
     */
    public static final CallCompositeTelecomManagerIntegrationMode SDK_PROVIDED_TELECOM_MANAGER =
            fromString("SDK_PROVIDED_TELECOM_MANAGER");

    /**
     * Use telecom manager managed by application.
     */
    public static final CallCompositeTelecomManagerIntegrationMode APPLICATION_IMPLEMENTED_TELECOM_MANAGER =
            fromString("APPLICATION_IMPLEMENTED_TELECOM_MANAGER");

    /**
     * Creates or finds a {@link CallCompositeTelecomManagerIntegrationMode} from its string representation.
     */
    public static CallCompositeTelecomManagerIntegrationMode fromString(final String name) {
        return fromString(name, CallCompositeTelecomManagerIntegrationMode.class);
    }

    /**
     * @return known {@link CallCompositeTelecomManagerIntegrationMode} values.
     */
    public static Collection<CallCompositeTelecomManagerIntegrationMode> values() {
        return values(CallCompositeTelecomManagerIntegrationMode.class);
    }
}
