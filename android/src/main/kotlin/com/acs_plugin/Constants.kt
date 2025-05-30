package com.acs_plugin


object Constants {

    object MethodChannels {
        const val GET_PRELOADED_ACTION = "getPreloadedAction"
        const val SET_USER_DATA = "setUserData"
        const val GET_TOKEN = "getToken"
        const val INITIALIZE_ROOM_CALL = "initializeRoomCall"
    }

    object FlutterEvents {
        const val ON_SHOW_CHAT = "onShowChat"
        const val ON_USER_CALL_ENDED = "onUserCallEnded"
    }

    object Prefs {
        const val PREFS_NAME = "user_data_prefs"
        const val USER_DATA_KEY = "user_data"
    }

    object Arguments {
        const val TOKEN = "token"
        const val NAME = "name"
        const val USER_ID = "userId"
        const val ROOM_ID = "roomId"
        const val IS_CHAT_ENABLED = "isChatEnable"
        const val IS_REJOINED = "isRejoin"
    }
}