package com.acs_plugin.chat;

import com.acs_plugin.chat.configuration.ChatCompositeConfiguration;
import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier;
import com.azure.android.communication.common.CommunicationTokenCredential;

/**
 * Builder for creating {@link ChatAdapter}.
 *
 * <p>Used to build a {@link ChatAdapter} which is then used to start a chat.</p>
 * <p>This class can be used to specify a locale to be used by the Chat Composite</p>
 */
public final class ChatAdapterBuilder {

    private String endpoint;
    private CommunicationIdentifier identity;
    private CommunicationTokenCredential credential;
    private String displayName;
    private String threadId;


    /**
     * Sets Azure Communication Service endpoint.
     * @param endpoint
     * @return
     */
    public ChatAdapterBuilder endpoint(final String endpoint) {
        this.endpoint = endpoint;
        return this;
    }

    /**
     * Sets Azure Communication identity.
     * @param identity
     * @return
     */
    public ChatAdapterBuilder identity(final CommunicationIdentifier identity) {
        this.identity = identity;
        return this;
    }

    /**
     * Sets Azure Communication credential
     * @param credential
     * @return
     */
    public ChatAdapterBuilder credential(final CommunicationTokenCredential credential) {
        this.credential = credential;
        return this;
    }

    /**
     * Sets chat participant display name
     * @param displayName
     * @return
     */
    public ChatAdapterBuilder displayName(final String displayName) {
        this.displayName = displayName;
        return this;
    }

    /**
     * Sets chat thread Id
     * @param threadId
     * @return
     */
    public ChatAdapterBuilder threadId(final String threadId) {
        this.threadId = threadId;
        return this;
    }

    /**
     * Builds the {@link ChatAdapter} class.
     *
     * @return {@link ChatAdapter}
     */
    public ChatAdapter build() {
        final ChatCompositeConfiguration config = new ChatCompositeConfiguration();
        return new ChatAdapter(config, endpoint, identity, credential, threadId, displayName);
    }
}
