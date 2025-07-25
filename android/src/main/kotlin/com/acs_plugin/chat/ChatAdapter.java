package com.acs_plugin.chat;

import android.content.Context;

import com.acs_plugin.chat.configuration.ChatCompositeConfiguration;
import com.acs_plugin.chat.models.ChatCompositeErrorEvent;
import com.acs_plugin.chat.models.ChatCompositeRemoteOptions;

import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier;
import com.azure.android.communication.common.CommunicationTokenCredential;
import java9.util.concurrent.CompletableFuture;

/**
 * Azure android communication chat composite component.
 *
 * <p><strong>Instantiating Chat Composite</strong></p>
 */
public final class ChatAdapter {

    private static int instanceIdCounter = 0;
    final Integer instanceId = instanceIdCounter++;
    private ChatContainer chatContainer;
    private final String endpoint;
    private final CommunicationIdentifier identity;
    private final CommunicationTokenCredential credential;
    private final String threadId;
    private final String displayName;
    private final ChatCompositeConfiguration configuration;

    ChatAdapter(final ChatCompositeConfiguration configuration,
                final String endpoint,
                final CommunicationIdentifier identity,
                final CommunicationTokenCredential credential,
                final String threadId,
                final String displayName) {

        this.endpoint = endpoint;
        this.identity = identity;
        this.credential = credential;
        this.threadId = threadId;
        this.displayName = displayName;
        this.configuration = configuration;
    }


    /**
     * Add {@link ChatCompositeEventHandler}.
     *
     * <p> A callback for Chat Composite Error Events.
     * See {@link ChatCompositeErrorEvent} for values.</p>
     * <pre>
     *
     * &#47;&#47; add error handler
     * chatAdapter.addOnErrorEventHandler&#40;event -> {
     *     &#47;&#47; Process error event
     *     System.out.println&#40;event.getCause&#40;&#41;&#41;;
     *     System.out.println&#40;event.getErrorCode&#40;&#41;&#41;;
     * }&#41;;
     *
     * </pre>
     *
     * @param errorHandler The {@link ChatCompositeEventHandler}.
     */
    public void addOnErrorEventHandler(final ChatCompositeEventHandler<ChatCompositeErrorEvent> errorHandler) {
        configuration.getEventHandlerRepository().addOnErrorEventHandler(errorHandler);
    }

    /**
     * Remove {@link ChatCompositeEventHandler}.
     *
     * <p> A callback for Chat Composite Error Events.
     * See {@link ChatCompositeErrorEvent} for values.</p>
     *
     * @param errorHandler The {@link ChatCompositeEventHandler}.
     */
    public void removeOnErrorEventHandler(final ChatCompositeEventHandler<ChatCompositeErrorEvent> errorHandler) {
        configuration.getEventHandlerRepository().removeOnErrorEventHandler(errorHandler);
    }

    /**
     * Connects to ACS service, starts realtime notifications.
     */
    public CompletableFuture<Void> connect(final Context context) {
        chatContainer = new ChatContainer(this, configuration, instanceId);

        launchComposite(context.getApplicationContext(), "");
        final CompletableFuture<Void> result = new CompletableFuture<>();
        result.complete(null);
        return result;
    }

    /**
     * Disconnects from backend services.
     */
    public void disconnect() {
        chatContainer.stop();
        chatContainer = null;
    }

    private void launchComposite(final Context context, final String threadId) {
        final ChatCompositeRemoteOptions remoteOptions =
                new ChatCompositeRemoteOptions(
                        endpoint, threadId, credential, identity, displayName != null ? displayName : "");
        chatContainer.start(context, remoteOptions);
    }
}
