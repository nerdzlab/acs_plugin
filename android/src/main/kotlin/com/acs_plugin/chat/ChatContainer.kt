package com.acs_plugin.chat

import android.content.Context
import com.acs_plugin.chat.configuration.ChatCompositeConfiguration
import com.acs_plugin.chat.configuration.ChatConfiguration
import com.acs_plugin.chat.error.ChatErrorHandler
import com.acs_plugin.chat.error.EventHandler
import com.acs_plugin.chat.locator.ServiceLocator
import com.acs_plugin.chat.logger.DefaultLogger
import com.acs_plugin.chat.logger.Logger
import com.acs_plugin.chat.models.ChatCompositeRemoteOptions
import com.acs_plugin.chat.redux.AppStore
import com.acs_plugin.chat.redux.Dispatch
import com.acs_plugin.chat.redux.action.ChatAction
import com.acs_plugin.chat.redux.middleware.repository.MessageRepositoryMiddlewareImpl
import com.acs_plugin.chat.redux.middleware.sdk.ChatActionHandler
import com.acs_plugin.chat.redux.middleware.sdk.ChatMiddlewareImpl
import com.acs_plugin.chat.redux.middleware.sdk.ChatServiceListener
import com.acs_plugin.chat.redux.reducer.AccessibilityReducerImpl
import com.acs_plugin.chat.redux.reducer.AppStateReducer
import com.acs_plugin.chat.redux.reducer.ChatReducerImpl
import com.acs_plugin.chat.redux.reducer.ErrorReducerImpl
import com.acs_plugin.chat.redux.reducer.LifecycleReducerImpl
import com.acs_plugin.chat.redux.reducer.NavigationReducerImpl
import com.acs_plugin.chat.redux.reducer.NetworkReducerImpl
import com.acs_plugin.chat.redux.reducer.ParticipantsReducerImpl
import com.acs_plugin.chat.redux.reducer.Reducer
import com.acs_plugin.chat.redux.reducer.RepositoryReducerImpl
import com.acs_plugin.chat.redux.state.AppReduxState
import com.acs_plugin.chat.redux.state.ReduxState
import com.acs_plugin.chat.repository.MessageRepository
import com.acs_plugin.chat.service.ChatService
import com.acs_plugin.chat.service.sdk.ChatEventHandler
import com.acs_plugin.chat.service.sdk.ChatFetchNotificationHandler
import com.acs_plugin.chat.service.sdk.ChatSDKWrapper
import com.acs_plugin.chat.utilities.CoroutineContextProvider
import com.acs_plugin.chat.utilities.TestHelper
import com.acs_plugin.chat.utilities.announceForAccessibility
import com.jakewharton.threetenabp.AndroidThreeTen

internal class ChatContainer(
    private val chatAdapter: ChatAdapter,
    private val configuration: ChatCompositeConfiguration,
    private val instanceId: Int,
) {
    companion object {
        lateinit var locator: ServiceLocator
    }

    private var started = false
    private var locator: ServiceLocator? = null

    fun start(
        context: Context,
        remoteOptions: ChatCompositeRemoteOptions,
    ) {
        // currently only single instance is supported
        if (!started) {
            AndroidThreeTen.init(context)
            started = true
            configuration.chatConfig =
                ChatConfiguration(
                    endpoint = remoteOptions.endpoint,
                    identity = remoteOptions.identity,
                    credential = remoteOptions.credential,
                    applicationID = DiagnosticConfig().tag,
                    sdkName = "com.azure.android:azure-communication-chat",
                    sdkVersion = "2.0.1",
                    threadId = remoteOptions.threadId,
                    senderDisplayName = remoteOptions.displayName
                )

            locator = initializeServiceLocator(
                instanceId,
                remoteOptions,
                context
            )
                .apply {
                    locate<Dispatch>()(ChatAction.StartChat())
                    locate<EventHandler>().start()
                    locate<ChatErrorHandler>().start()
                }
        }
    }

    private fun initializeServiceLocator(
        instanceId: Int,
        remoteOptions: ChatCompositeRemoteOptions,
        context: Context,
    ) =
        ServiceLocator.getInstance(instanceId = instanceId).apply {
            addTypedBuilder { TestHelper.coroutineContextProvider ?: CoroutineContextProvider() }

            val messageRepository = MessageRepository.createSkipListBackedRepository()

            addTypedBuilder { chatAdapter }

            addTypedBuilder { messageRepository }

            addTypedBuilder { remoteOptions }

            addTypedBuilder { ChatEventHandler() }

            addTypedBuilder {
                ChatFetchNotificationHandler(
                    coroutineContextProvider = locate(),
                    localParticipantIdentifier = configuration.chatConfig?.identity ?: ""
                )
            }

            addTypedBuilder {
                ChatSDKWrapper(
                    context = context,
                    chatConfig = configuration.chatConfig!!,
                    coroutineContextProvider = locate(),
                    chatEventHandler = locate(),
                    chatFetchNotificationHandler = locate(),
                    logger = locate()
                )
            }

            addTypedBuilder {
                ChatService(
                    chatSDK = TestHelper.chatSDK ?: locate<ChatSDKWrapper>()
                )
            }

            addTypedBuilder {
                ChatServiceListener(
                    chatService = locate(),
                    coroutineContextProvider = locate()
                )
            }

            addTypedBuilder {
                AppStore(
                    initialState = AppReduxState(
                        configuration.chatConfig!!.threadId,
                        configuration.chatConfig!!.identity,
                        configuration.chatConfig?.senderDisplayName
                    ),
                    reducer = AppStateReducer(
                        chatReducer = ChatReducerImpl(),
                        participantReducer = ParticipantsReducerImpl(),
                        lifecycleReducer = LifecycleReducerImpl(),
                        errorReducer = ErrorReducerImpl(),
                        navigationReducer = NavigationReducerImpl(),
                        repositoryReducer = RepositoryReducerImpl(),
                        networkReducer = NetworkReducerImpl(),
                        accessibilityReducer = AccessibilityReducerImpl(context) {
                            announceForAccessibility(context, it)
                        },
                    ) as Reducer<ReduxState>,
                    middlewares = mutableListOf(
                        ChatMiddlewareImpl(
                            chatActionHandler = ChatActionHandler(
                                chatService = locate()
                            ),
                            chatServiceListener = locate()
                        ),
                        MessageRepositoryMiddlewareImpl(messageRepository)
                    ),
                    dispatcher = (locate() as CoroutineContextProvider).SingleThreaded
                )
            }

            addTypedBuilder<Dispatch> { locate<AppStore<ReduxState>>()::dispatch }

            addTypedBuilder {
                EventHandler(
                    coroutineContextProvider = locate(),
                    store = locate(),
                    configuration = configuration,
                )
            }

            addTypedBuilder {
                ChatErrorHandler(
                    coroutineContextProvider = locate(),
                    store = locate(),
                    configuration = configuration,
                )
            }
            addTypedBuilder<Logger> { DefaultLogger() }
        }

    fun stop() {
        locator?.locate<EventHandler>()?.stop()
        locator?.locate<ChatErrorHandler>()?.stop()
        locator?.locate<ChatSDKWrapper>()?.destroy()
        locator?.locate<ChatServiceListener>()?.unsubscribe()
        locator?.locate<AppStore<ReduxState>>()?.end()
        locator?.clear()
        locator = null
    }
}
