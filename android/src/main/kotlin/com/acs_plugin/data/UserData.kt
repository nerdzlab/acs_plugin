package com.acs_plugin.data

import kotlinx.serialization.InternalSerializationApi
import kotlinx.serialization.Serializable

@OptIn(InternalSerializationApi::class)
@Serializable
data class UserData(
    val token: String,
    val name: String,
    val userId: String
)
