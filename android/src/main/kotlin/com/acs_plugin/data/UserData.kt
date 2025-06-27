package com.acs_plugin.data

import com.acs_plugin.consts.PluginConstants
import kotlinx.serialization.Serializable
import kotlinx.serialization.InternalSerializationApi

@OptIn(InternalSerializationApi::class)
@Serializable
data class UserData(
    val token: String,
    val name: String,
    val userId: String,
    val languageCode: String = PluginConstants.Base.DEFAULT_LANGUAGE_CODE
)
