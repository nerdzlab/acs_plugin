package com.acs_plugin.calling.models

import kotlinx.serialization.Serializable

@OptIn(kotlinx.serialization.InternalSerializationApi::class)
@Serializable
@JvmInline
value class ReactionMessage(
    val map: Map<String, ReactionPayload>
)
