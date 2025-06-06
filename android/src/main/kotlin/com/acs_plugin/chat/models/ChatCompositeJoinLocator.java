package com.acs_plugin.chat.models;

import com.acs_plugin.chat.ChatAdapter;

/**
 * Chat locator to join chat experience using {@link ChatAdapter}.
 */
final class ChatCompositeJoinLocator {

    private final String chatThreadId;
    private final String endpoint;

    /**
     * Creates {@link ChatCompositeJoinLocator}.
     *
     * @param chatThreadId Chat thread id.
     * @param endpoint  Chat end point URL.
     */
    ChatCompositeJoinLocator(final String chatThreadId, final String endpoint) {
        this.chatThreadId = chatThreadId;
        this.endpoint = endpoint;
    }

    /**
     * Get chat thread id.
     *
     * @return {@link String}
     */
    public String getChatThreadId() {
        return chatThreadId;
    }

    /**
     * Get chat end point URL.
     *
     * @return {@link String}
     */
    public String getEndpoint() {
        return endpoint;
    }
}
