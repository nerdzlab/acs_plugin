package com.acs_plugin.chat.service.sdk.wrapper


internal sealed class CommunicationIdentifier(val id: String) {
    data class CommunicationUserIdentifier(val userId: String) : CommunicationIdentifier(userId)
    data class MicrosoftTeamsUserIdentifier(val userId: String, val isAnonymous: Boolean) :
        CommunicationIdentifier(userId)

    data class PhoneNumberIdentifier(val phoneNumber: String) : CommunicationIdentifier(phoneNumber)
    data class UnknownIdentifier(val genericId: String) : CommunicationIdentifier(genericId)
}

internal fun com.azure.android.communication.common.CommunicationIdentifier.into(): CommunicationIdentifier {
    return when (this) {
        is CommunicationIdentifier.CommunicationUserIdentifier -> CommunicationIdentifier.CommunicationUserIdentifier(
            this.id
        )

        is CommunicationIdentifier.MicrosoftTeamsUserIdentifier -> CommunicationIdentifier.MicrosoftTeamsUserIdentifier(
            this.userId,
            this.isAnonymous
        )

        is CommunicationIdentifier.PhoneNumberIdentifier -> CommunicationIdentifier.PhoneNumberIdentifier(this.phoneNumber)
        is CommunicationIdentifier.UnknownIdentifier -> CommunicationIdentifier.UnknownIdentifier(this.id)
        else -> {
            throw IllegalStateException("Unknown type of CommunicationIdentifier: $this")
        }
    }
}

internal fun CommunicationIdentifier.into(): com.azure.android.communication.common.CommunicationIdentifier {
    return when (this) {
        is CommunicationIdentifier.CommunicationUserIdentifier -> com.azure.android.communication.common.CommunicationUserIdentifier(
            this.userId
        )

        is CommunicationIdentifier.MicrosoftTeamsUserIdentifier -> com.azure.android.communication.common.MicrosoftTeamsUserIdentifier(
            this.userId,
            this.isAnonymous
        )

        is CommunicationIdentifier.PhoneNumberIdentifier -> com.azure.android.communication.common.PhoneNumberIdentifier(this.phoneNumber)
        is CommunicationIdentifier.UnknownIdentifier -> com.azure.android.communication.common.UnknownIdentifier(this.genericId)
    }
}
