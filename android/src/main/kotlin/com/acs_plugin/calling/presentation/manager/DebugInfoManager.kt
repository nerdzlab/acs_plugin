// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.manager

import com.acs_plugin.calling.data.CallHistoryRepository
import com.acs_plugin.calling.models.CallCompositeCallHistoryRecord
import com.acs_plugin.calling.models.CallCompositeDebugInfo
import com.acs_plugin.calling.models.buildCallCompositeDebugInfo
import com.acs_plugin.calling.models.buildCallHistoryRecord
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import java.io.File

internal interface DebugInfoManager {
    fun getDebugInfo(): CallCompositeDebugInfo
}

internal class DebugInfoManagerImpl(
    private val callHistoryRepository: CallHistoryRepository,
    private val getLogFiles: () -> List<File>,
) : DebugInfoManager {

    override fun getDebugInfo(): CallCompositeDebugInfo {
        val callHistory = runBlocking {
            withContext(Dispatchers.IO) { getCallHistory() }
        }
        return buildCallCompositeDebugInfo(callHistory, getLogFiles)
    }

    private suspend fun getCallHistory(): List<CallCompositeCallHistoryRecord> {
        return callHistoryRepository.getAll()
            .groupBy {
                it.callStartedOn
            }
            .map { mapped ->
                buildCallHistoryRecord(mapped.key, mapped.value.map { it.callId })
            }
            .sortedBy {
                it.callStartedOn
            }
    }
}
