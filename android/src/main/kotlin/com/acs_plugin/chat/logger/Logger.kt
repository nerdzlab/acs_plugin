package com.acs_plugin.chat.logger

internal interface Logger {
    fun info(message: String, throwable: Throwable? = null)
    fun debug(message: String, throwable: Throwable? = null)
    fun warning(message: String, throwable: Throwable? = null)
    fun error(message: String, error: Throwable?)
}
