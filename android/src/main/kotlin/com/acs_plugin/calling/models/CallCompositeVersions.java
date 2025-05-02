// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

import androidx.annotation.NonNull;

/**
 * This class provides a snapshot of version information for critical calling dependencies within the application.
 * It encapsulates the versions of both the Azure Calling UI SDK and the underlying Azure Calling SDK.
 */
public class CallCompositeVersions {

    /**
     * Retrieves the version of the Azure Calling UI SDK.
     * This version reflects the UI components specifically designed for Azure calling features.
     *
     * @return A {@link String} representing the version of the Azure Calling UI SDK.
     */
    public String getAzureCallingUILibrary() {
        return "1.14.0";
    }

    /**
     * Retrieves the version of the Azure Calling SDK.
     * This version indicates the core library's version that powers the calling capabilities.
     *
     * @return A {@link String} representing the version of the Azure Calling SDK.
     */
    public String getAzureCallingLibrary() {
        return "2.13.1";
    }

    /**
     * Provides a string representation of the CallCompositeVersions object, including versions of both
     * the Azure Calling UI SDK and the Azure Calling SDK.
     *
     * @return A {@link String} representation of the object, detailing the versions of included SDKs.
     */
    @NonNull
    @Override
    public String toString() {
        return "CallCompositeVersions{"
                + "AzureCallingUILibrary='" + getAzureCallingUILibrary() + '\''
                + ", AzureCallingLibrary='" + getAzureCallingLibrary() + '\''
                + '}';
    }
}
