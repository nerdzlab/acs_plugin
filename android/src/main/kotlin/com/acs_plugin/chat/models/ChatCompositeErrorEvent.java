package com.acs_plugin.chat.models;

/**
 * Event with error type and caused throwable.
 */
public final class ChatCompositeErrorEvent {
    private final String threadId;
    private final Throwable cause;
    private final ChatCompositeErrorCode code;

    /**
     * Create {@link ChatCompositeErrorEvent} with error code and caused throwable.
     *
     * @param code  Error code {@link ChatCompositeErrorCode}.
     * @param cause Throwable that caused an exception.
     */
    public ChatCompositeErrorEvent(
            final String threadId,
            final ChatCompositeErrorCode code,
            final Throwable cause) {
        this.threadId = threadId;
        this.cause = cause;
        this.code = code;
    }

    /**
     * Returns the cause of this throwable or {@code null} if the
     * cause is nonexistent or unknown. (The cause is the throwable that
     * caused this throwable to get thrown).
     *
     * @return the cause of this throwable or {@code null} if the
     * cause is nonexistent or unknown.
     */
    public Throwable getCause() {
        return cause;
    }

    /**
     * Returns the event source.
     *
     * @return the chat error code {@link ChatCompositeErrorCode} instance.
     */
    public ChatCompositeErrorCode getErrorCode() {
        return code;
    }

    /**
     * Returns threadId associated with error.
     * @return
     */
    public String getThreadId() {
        return threadId;
    }
}
