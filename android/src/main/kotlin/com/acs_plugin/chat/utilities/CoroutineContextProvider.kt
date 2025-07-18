package com.acs_plugin.chat.utilities

import java.util.concurrent.Executors
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.asCoroutineDispatcher
import kotlin.coroutines.CoroutineContext

internal open class CoroutineContextProvider {
    open val Main: CoroutineContext by lazy { Dispatchers.Main }
    open val IO: CoroutineContext by lazy { Dispatchers.IO }
    open val Default: CoroutineContext by lazy { Dispatchers.Default }
    open val SingleThreaded: CoroutineContext by lazy {
        Executors.newSingleThreadExecutor().asCoroutineDispatcher()
    }
}
