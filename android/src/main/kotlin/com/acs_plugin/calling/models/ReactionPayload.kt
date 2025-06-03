package com.acs_plugin.calling.models

import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@OptIn(kotlinx.serialization.InternalSerializationApi::class)
@Serializable
data class ReactionPayload(
    @SerialName("reaction")
    val reaction: ReactionType,

    @SerialName("receivedOn")
    val receivedOn: Long? = null
)
