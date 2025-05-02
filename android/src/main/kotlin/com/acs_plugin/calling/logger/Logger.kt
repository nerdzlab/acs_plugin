// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.logger

internal interface Logger {
    fun info(message: String)
    fun debug(message: String)
    fun warning(message: String)
    fun error(message: String, error: Throwable? = null)
}
