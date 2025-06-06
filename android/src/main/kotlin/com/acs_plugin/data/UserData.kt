package com.acs_plugin.data

import kotlinx.serialization.Serializable
import kotlinx.serialization.InternalSerializationApi

@OptIn(InternalSerializationApi::class)
@Serializable
data class UserData(
    val token: String,
    val name: String,
    val userId: String
)
