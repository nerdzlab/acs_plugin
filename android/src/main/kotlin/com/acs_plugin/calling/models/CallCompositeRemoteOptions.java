// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

import android.content.Context;

import com.azure.android.communication.common.CommunicationTokenCredential;
import com.acs_plugin.calling.CallComposite;
import com.acs_plugin.calling.CallCompositeBuilder;

/**
 * CallCompositeRemoteOptions for CallComposite.launch.
 * @deprecated use {@link CallComposite} launch with {@link CallCompositeJoinLocator}.
 * Build composite using {@link CallCompositeBuilder#build(Context, CommunicationTokenCredential)}.
 * <pre>
 *
 * &#47;&#47; Initialize the call composite builder
 * final CallCompositeBuilder builder = new CallCompositeBuilder&#40;&#41;;
 *
 * &#47;&#47; Build the call composite
 * CallComposite callComposite = builder.build&#40;&#41;;
 *
 * &#47;&#47; Build the CallCompositeRemoteOptions with {@link CommunicationTokenCredential}
 * {@link CallCompositeJoinLocator}
 * CallCompositeRemoteOptions remoteOptions = new CallCompositeRemoteOptions&#40;
 *     locator, communicationTokenCredential, displayName&#41;
 *
 * &#47;&#47; Launch call
 * callComposite.launch&#40;.., remoteOptions&#41
 * </pre>
 *
 * @see CallComposite
 */
@Deprecated
public final class CallCompositeRemoteOptions {
    // Mandatory
    private final CommunicationTokenCredential credential;
    private final CallCompositeJoinLocator locator;

    // Optional
    private final String displayName;

    /**
     * Create {@link CallCompositeRemoteOptions}.
     *
     * @param locator {@link CallCompositeJoinLocator}.
     * @param credential {@link CommunicationTokenCredential}.
     */
    public CallCompositeRemoteOptions(
            final CallCompositeJoinLocator locator,
            final CommunicationTokenCredential credential) {
        this(locator, credential, "");
    }

    /**
     * Create {@link CallCompositeRemoteOptions}.
     *
     * @param locator {@link CallCompositeJoinLocator}.
     * @param credential {@link CommunicationTokenCredential}.
     * @param displayName User display name other call participants will see.
     */
    public CallCompositeRemoteOptions(
            final CallCompositeJoinLocator locator,
            final CommunicationTokenCredential credential,
            final String displayName) {

        this.credential = credential;
        this.displayName = displayName;
        this.locator = locator;
    }

    /**
     * Get {@link CommunicationTokenCredential}.
     *
     * @return {@link String}.
     */
    public CommunicationTokenCredential getCredential() {
        return credential;
    }

    /**
     * Get user display name.
     *
     * @return {@link String}.
     */
    public String getDisplayName() {
        return displayName;
    }

    /**
     * Get call locator.
     *
     * @return {@link CallCompositeJoinLocator}.
     */
    public CallCompositeJoinLocator getLocator() {
        return locator;
    }
}
