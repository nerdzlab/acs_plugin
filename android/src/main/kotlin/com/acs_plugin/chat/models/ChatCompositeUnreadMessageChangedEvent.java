package com.acs_plugin.chat.models;

/**
 * Unread message count changed event.
 */
final class ChatCompositeUnreadMessageChangedEvent {
    private final int count;

    ChatCompositeUnreadMessageChangedEvent(final int count) {
        this.count = count;
    }

    /**
     * Get unread message changed count.
     *
     * @return int count.
     */
    public int getCount() {
        return count;
    }

    String getThreadID() {
        return "";
    }
}
