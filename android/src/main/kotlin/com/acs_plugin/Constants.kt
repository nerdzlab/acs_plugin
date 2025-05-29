package com.acs_plugin

object Constants {

    object MethodChannels {
        const val SET_USER_DATA = "setUserData"
        const val GET_TOKEN = "getToken"
    }

    object FlutterEvents {
        const val ON_SHOW_CHAT = "onShowChat"
        const val ON_USER_CALL_ENDED = "onUserCallEnded"
    }

    object Prefs {
        const val PREFS_NAME = "user_data_prefs"
        const val USER_DATA_KEY = "user_data"
    }
}