package com.acs_plugin

object Constants {

    object MethodChannels {
        const val SETUP_CHAT_SERVICE = "setupChatService"
        const val DISCONNECT_CHAT_SERVICE = "disconnectChatService"
        const val INIT_CHAT_THREAD = "initChatThread"
        const val GET_INITIAL_MESSAGES = "getInitialMessages"
        const val RETRIEVE_CHAT_THREAD_PROPERTIES = "retrieveChatThreadProperties"
        const val GET_LIST_OF_PARTICIPANTS = "getListOfParticipants"
        const val GET_PREVIOUS_MESSAGES = "getPreviousMessages"
        const val GET_LAST_MESSAGE = "getLastMessage"
        const val SEND_MESSAGE = "sendMessage"
        const val EDIT_MESSAGE = "editMessage"
        const val DELETE_MESSAGE = "deleteMessage"
        const val SEND_READ_RECEIPT = "sendReadReceipt"
        const val SEND_TYPING_INDICATOR = "sendTypingIndicator"
        const val IS_CHAT_HAS_MORE_MESSAGES = "isChatHasMoreMessages"
        const val GET_LIST_READ_RECEIPTS = "getListReadReceipts"
        const val SET_USER_DATA = "setUserData"
        const val GET_TOKEN = "getToken"
    }

    object FlutterEvents {
        const val ON_CHAT_ERROR = "onChatError"
        const val ON_REMOTE_PARTICIPANT_JOINED = "onRemoteParticipantJoined"
        const val ON_UNREAD_MESSAGES_COUNT_CHANGED = "onUnreadMessagesCountChanged"
        const val ON_NEW_MESSAGE_RECEIVED = "onNewMessageReceived"
        const val ON_REAL_TIME_NOTIFICATION_CONNECTED = "onRealTimeNotificationConnected"
        const val ON_REAL_TIME_NOTIFICATION_DISCONNECTED = "onRealTimeNotificationDisconnected"
        const val ON_CHAT_MESSAGE_RECEIVED = "onChatMessageReceived"
        const val ON_TYPING_INDICATOR_RECEIVED = "onTypingIndicatorReceived"
        const val ON_READ_RECEIPT_RECEIVED = "onReadReceiptReceived"
        const val ON_CHAT_MESSAGE_EDITED = "onChatMessageEdited"
        const val ON_CHAT_MESSAGE_DELETED = "onChatMessageDeleted"
        const val ON_CHAT_THREAD_CREATED = "onChatThreadCreated"
        const val ON_CHAT_THREAD_PROPERTIES_UPDATED = "onChatThreadPropertiesUpdated"
        const val ON_CHAT_THREAD_DELETED = "onChatThreadDeleted"
        const val ON_PARTICIPANTS_ADDED = "onParticipantsAdded"
        const val ON_PARTICIPANTS_REMOVED = "onParticipantsRemoved"
        const val ON_CHAT_PUSH_NOTIFICATION_OPENED = "onChatPushNotificationOpened"
    }

    object Prefs {
        const val PREFS_NAME = "user_data_prefs"
        const val USER_DATA_KEY = "user_data"
    }
}