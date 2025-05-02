// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling

import android.content.Context
import com.acs_plugin.calling.data.CallHistoryRepositoryImpl
import com.acs_plugin.calling.logger.DefaultLogger
import com.acs_plugin.calling.presentation.manager.DebugInfoManager
import com.acs_plugin.calling.presentation.manager.DebugInfoManagerImpl
import java.io.File

internal fun createDebugInfoManager(context: Context, getLogFiles: () -> List<File>): DebugInfoManager {
    return DebugInfoManagerImpl(CallHistoryRepositoryImpl(context, DefaultLogger()), getLogFiles)
}

internal fun CallComposite.getDiContainer() =
    CallComposite.diContainer

internal fun CallComposite.onExit() {
    CallComposite.diContainer = null
}
