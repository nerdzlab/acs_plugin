package com.acs_plugin.chat.redux.middleware.sdk

import com.acs_plugin.chat.redux.Dispatch
import com.acs_plugin.chat.redux.Middleware
import com.acs_plugin.chat.redux.Store
import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.action.ChatAction
import com.acs_plugin.chat.redux.state.ReduxState

internal interface ChatMiddleware

// ChatMiddleware
//
// Manages
// ChatServiceListener (Service -> Redux)
// ChatActionHandler (Redux -> Service)
internal class ChatMiddlewareImpl(
    private val chatServiceListener: ChatServiceListener,
    private val chatActionHandler: ChatActionHandler,
) :
    Middleware<ReduxState>,
    ChatMiddleware {

    override fun invoke(store: Store<ReduxState>) = { next: Dispatch ->
        { action: Action ->
            // Handle Service Subscription/UnSubscription of service
            when (action) {
                is ChatAction.StartChat -> {
                    chatServiceListener.subscribe(store)
                }
                is ChatAction.EndChat -> {
                    chatServiceListener.unsubscribe()
                }
            }

            // Forward Actions to ChatActionHandler
            chatActionHandler.onAction(
                action = action,
                dispatch = store::dispatch,
                state = store.getCurrentState()
            )

            // Pass Action down the chain
            next(action)
        }
    }
}
