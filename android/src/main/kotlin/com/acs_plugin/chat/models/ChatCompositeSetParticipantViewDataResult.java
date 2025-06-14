package com.acs_plugin.chat.models;

import com.azure.android.communication.common.CommunicationIdentifier;
import com.acs_plugin.chat.ChatAdapter;
import com.azure.android.core.util.ExpandableStringEnum;

import java.util.Collection;

/**
 * Result values for
 * {@link ChatAdapter#setRemoteParticipantViewData(CommunicationIdentifier, ChatCompositeParticipantViewData)}.
 */
final class ChatCompositeSetParticipantViewDataResult
        extends ExpandableStringEnum<ChatCompositeSetParticipantViewDataResult> {

    /**
     * The Remote Participant View Data was Successfully set.
     */
    public static final ChatCompositeSetParticipantViewDataResult SUCCESS = fromString("success");

    /**
     * The Remote Participant was not in the chat.
     */
    public static final ChatCompositeSetParticipantViewDataResult PARTICIPANT_NOT_IN_CHAT
            = fromString("participantNotInChat");

    ChatCompositeSetParticipantViewDataResult() {

    }

    /**
     * Creates or finds a {@link ChatCompositeSetParticipantViewDataResult} from it's string representation.
     *
     * @param name a name to look for.
     * @return the corresponding {@link ChatCompositeSetParticipantViewDataResult}.
     */
    private static ChatCompositeSetParticipantViewDataResult fromString(final String name) {
        return fromString(name, ChatCompositeSetParticipantViewDataResult.class);
    }

    /**
     * @return collection of {@link ChatCompositeSetParticipantViewDataResult} values.
     */
    public static Collection<ChatCompositeSetParticipantViewDataResult> values() {
        return values(ChatCompositeSetParticipantViewDataResult.class);
    }
}

