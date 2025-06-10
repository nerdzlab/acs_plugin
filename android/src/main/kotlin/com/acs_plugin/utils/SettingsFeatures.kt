package com.acs_plugin.utils

import android.content.Context
import android.content.SharedPreferences
import android.util.LayoutDirection
import com.acs_plugin.calling.models.CallCompositeSupportedScreenOrientation
import com.acs_plugin.calling.models.CallCompositeTelecomManagerIntegrationMode
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import java.util.*

class SettingsFeatures {

    companion object {

        private const val SETTINGS_SHARED_PREFS = "settings_shared_prefs"

        // Language constants
        private const val LANGUAGE_ADAPTER_VALUE_SHARED_PREF_KEY = "language_adapter_value"
        private const val LANGUAGE_ISRTL_VALUE_SHARED_PREF_KEY = "language_isrtl_value_"
        private const val DEFAULT_LANGUAGE_VALUE = "en"
        private const val DEFAULT_RTL_VALUE = false

        // Captions constants
        private const val DEFAULT_SPOKEN_LANGUAGE_KEY = "default_spoken_language"
        private const val DEFAULT_SPOKEN_LANGUAGE = "en-US"
        private const val AUTO_START_CAPTIONS = "auto_start_captions"
        private const val DEFAULT_AUTO_START_CAPTIONS = false
        private const val HIDE_CAPTIONS_UI = "hide_captions_ui"
        private const val DEFAULT_HIDE_CAPTIONS_UI = false

        // Call information constants
        private const val CALL_INFORMATION_TITLE_UPDATE_PARTICIPANT_COUNT_KEY = "call_info_title_update_count"
        private const val CALL_INFORMATION_TITLE_UPDATE_PARTICIPANT_COUNT_VALUE = 5
        private const val CALL_INFORMATION_SUBTITLE_UPDATE_PARTICIPANT_COUNT_KEY = "call_info_subtitle_update_count"
        private const val CALL_INFORMATION_SUBTITLE_UPDATE_PARTICIPANT_COUNT_VALUE = 3
        private const val CALL_INFORMATION_SUBTITLE_KEY = "call_info_subtitle"
        private const val CALL_INFORMATION_SUBTITLE_DEFAULT = "Default Subtitle"
        private const val CALL_INFORMATION_TITLE_KEY = "call_info_title"
        private const val CALL_INFORMATION_DEFAULT_TITLE = "Default Title"

        // Call duration constants
        private const val SHOW_CALL_DURATION_KEY = "show_call_duration"
        private const val DEFAULT_SHOW_CALL_DURATION = true

        // Persona injection constants
        private const val PERSONA_INJECTION_VALUE_PREF_KEY = "persona_injection_avatar"
        private const val PERSONA_INJECTION_DISPLAY_NAME_KEY = "persona_injection_display_name"

        // Setup screen constants
        private const val SKIP_SETUP_SCREEN_VALUE_KEY = "skip_setup_screen"
        private const val DEFAULT_SKIP_SETUP_SCREEN_VALUE = false
        private const val SETUP_SCREEN_CAMERA_ENABLED = "setup_screen_camera_enabled"
        private const val DEFAULT_SETUP_SCREEN_CAMERA_ENABLED_VALUE = true
        private const val SETUP_SCREEN_MIC_ENABLED = "setup_screen_mic_enabled"
        private const val DEFAULT_SETUP_SCREEN_MIC_ENABLED_VALUE = true

        // Audio/Video defaults
        private const val MIC_ON_BY_DEFAULT_KEY = "mic_on_by_default"
        private const val DEFAULT_MIC_ON_BY_DEFAULT_VALUE = false
        private const val CAMERA_ON_BY_DEFAULT_KEY = "camera_on_by_default"
        private const val DEFAULT_CAMERA_ON_BY_DEFAULT_VALUE = false
        private const val AUDIO_ONLY_MODE_ON = "audio_only_mode_on"
        private const val DEFAULT_AUDIO_ONLY_MODE_ON = false

        // UI constants
        private const val DISPLAY_DISMISS_BUTTON_KEY = "display_dismiss_button"
        private const val DISPLAY_DISMISS_BUTTON_KEY_DEFAULT_VALUE = true
        private const val DISPLAY_LEAVE_CALL_CONFIRMATION_VALUE = "display_leave_call_confirmation"
        private const val DEFAULT_DISPLAY_LEAVE_CALL_CONFIRMATION_VALUE = true

        // Push notifications
        private const val DISABLE_INTERNAL_PUSH_NOTIFICATIONS = "disable_internal_push_notifications"

        // Launch options
        private const val USE_DEPRECATED_LAUNCH_KEY = "use_deprecated_launch"

        // Display options
        private const val RENDERED_DISPLAY_NAME = "rendered_display_name"
        private const val AVATAR_IMAGE = "avatar_image"
        private const val CALL_TITLE = "call_title"
        private const val CALL_SUBTITLE = "call_subtitle"

        // Orientation constants
        private const val CALL_SCREEN_ORIENTATION_SHARED_PREF_KEY = "call_screen_orientation"
        private const val SETUP_SCREEN_ORIENTATION_SHARED_PREF_KEY = "setup_screen_orientation"

        // Telecom manager
        private const val TELECOM_MANAGER_INTEGRATION_OPTION_KEY = "telecom_manager_integration"

        // Multitasking constants
        private const val ENABLE_MULTITASKING = "enable_multitasking"
        private const val ENABLE_MULTITASKING_DEFAULT_VALUE = false
        private const val ENABLE_PIP_WHEN_MULTITASKING = "enable_pip_when_multitasking"
        private const val ENABLE_PIP_WHEN_MULTITASKING_DEFAULT_VALUE = false

        // Custom buttons
        private const val ADD_CUSTOM_BUTTONS_KEY = "add_custom_buttons"
        private const val DEFAULT_ADD_CUSTOM_BUTTONS = false


        private lateinit var sharedPrefs: SharedPreferences
        private val defaultLocaleString = Gson().toJson(Locale.US)

        fun initialize(context: Context) {
            sharedPrefs = context.getSharedPreferences(SETTINGS_SHARED_PREFS, Context.MODE_PRIVATE)
        }

        fun language(): String? {
            return sharedPrefs.getString(
                LANGUAGE_ADAPTER_VALUE_SHARED_PREF_KEY,
                null,
            )
        }

        fun getCaptionsDefaultSpokenLanguage(): String? {
            return sharedPrefs.getString(
                DEFAULT_SPOKEN_LANGUAGE_KEY,
                DEFAULT_SPOKEN_LANGUAGE,
            )
        }
        fun getCallScreenInformationTitleUpdateParticipantCount(): Int {
            return sharedPrefs.getInt(
                CALL_INFORMATION_TITLE_UPDATE_PARTICIPANT_COUNT_KEY,
                CALL_INFORMATION_TITLE_UPDATE_PARTICIPANT_COUNT_VALUE,
            )
        }

        fun getCallScreenInformationSubtitleUpdateParticipantCount(): Int {
            return sharedPrefs.getInt(
                CALL_INFORMATION_SUBTITLE_UPDATE_PARTICIPANT_COUNT_KEY,
                CALL_INFORMATION_SUBTITLE_UPDATE_PARTICIPANT_COUNT_VALUE,
            )
        }

        fun getCallScreenInformationSubtitle(): String? {
            return sharedPrefs.getString(
                CALL_INFORMATION_SUBTITLE_KEY,
                CALL_INFORMATION_SUBTITLE_DEFAULT,
            )
        }

        fun getCallScreenInformationTitle(): String? {
            return sharedPrefs.getString(
                CALL_INFORMATION_TITLE_KEY,
                CALL_INFORMATION_DEFAULT_TITLE,
            )
        }

        fun getCallScreenShowCallDuration(): Boolean? {
            return if (sharedPrefs.contains(SHOW_CALL_DURATION_KEY)) {
                sharedPrefs.getBoolean(
                    SHOW_CALL_DURATION_KEY,
                    DEFAULT_SHOW_CALL_DURATION
                )
            } else {
                null
            }
        }

        fun getLayoutDirection(): Int? {
            val isRTLKey =
                LANGUAGE_ISRTL_VALUE_SHARED_PREF_KEY +
                        sharedPrefs.getString(
                            LANGUAGE_ADAPTER_VALUE_SHARED_PREF_KEY,
                            DEFAULT_LANGUAGE_VALUE,
                        )
            return if (sharedPrefs.contains(isRTLKey)) {
                if (sharedPrefs.getBoolean(isRTLKey, DEFAULT_RTL_VALUE)) {
                    LayoutDirection.RTL
                } else {
                    LayoutDirection.LTR
                }
            } else {
                null
            }
        }

        fun locale(languageDisplayName: String?): Locale? {
            if (languageDisplayName == null) {
                return null
            }

            val localeString = sharedPrefs.getString(languageDisplayName, null)
            return if (localeString != null) {
                GsonBuilder().create().fromJson(localeString, Locale::class.java)
            } else {
                null
            }
        }

        fun orientation(orientationDisplayName: String?): CallCompositeSupportedScreenOrientation? {
            return orientationDisplayName?.let {
                CallCompositeSupportedScreenOrientation.fromString(orientationDisplayName)
            }
        }

        fun displayLanguageName(locale: Locale): String {
            val displayName = locale.displayName
            val localeString = Gson().toJson(locale)
            sharedPrefs.edit().putString(displayName, localeString).apply()
            return displayName
        }

        fun displayOrientationName(orientation: CallCompositeSupportedScreenOrientation): String {
            val displayName = orientation.toString()
            return displayName
        }

        fun displayTelecomManagerOptionName(option: CallCompositeTelecomManagerIntegrationMode): String {
            return option.toString()
        }

        fun getInjectionAvatarForRemoteParticipantSelection(): Boolean {
            return sharedPrefs.getBoolean(PERSONA_INJECTION_VALUE_PREF_KEY, false)
        }

        fun getInjectionDisplayNameRemoteParticipantSelection(): Boolean {
            return sharedPrefs.getBoolean(PERSONA_INJECTION_DISPLAY_NAME_KEY, false)
        }

        fun getSkipSetupScreenFeatureOption(): Boolean? {
            return if (sharedPrefs.contains(SKIP_SETUP_SCREEN_VALUE_KEY)) {
                sharedPrefs.getBoolean(SKIP_SETUP_SCREEN_VALUE_KEY, DEFAULT_SKIP_SETUP_SCREEN_VALUE)
            } else {
                null
            }
        }

        fun getMicOnByDefaultOption(): Boolean? {
            return if (sharedPrefs.contains(MIC_ON_BY_DEFAULT_KEY)) {
                sharedPrefs.getBoolean(MIC_ON_BY_DEFAULT_KEY, DEFAULT_MIC_ON_BY_DEFAULT_VALUE)
            } else {
                null
            }
        }

        fun getCameraOnByDefaultOption(): Boolean? {
            return if (sharedPrefs.contains(CAMERA_ON_BY_DEFAULT_KEY)) {
                sharedPrefs.getBoolean(CAMERA_ON_BY_DEFAULT_KEY, DEFAULT_CAMERA_ON_BY_DEFAULT_VALUE)
            } else {
                null
            }
        }

        fun getAudioOnlyByDefaultOption(): Boolean? {
            return if (sharedPrefs.contains(AUDIO_ONLY_MODE_ON)) {
                sharedPrefs.getBoolean(AUDIO_ONLY_MODE_ON, DEFAULT_AUDIO_ONLY_MODE_ON)
            } else {
                null
            }
        }

        fun getDisplayDismissButtonOption(): Boolean {
            if (!this::sharedPrefs.isInitialized) return false
            return sharedPrefs.getBoolean(DISPLAY_DISMISS_BUTTON_KEY, DISPLAY_DISMISS_BUTTON_KEY_DEFAULT_VALUE)
        }

        fun getDisableInternalPushForIncomingCallCheckbox(): Boolean {
            return sharedPrefs.getBoolean(DISABLE_INTERNAL_PUSH_NOTIFICATIONS, false)
        }

        fun getUseDeprecatedLaunch(): Boolean {
            return sharedPrefs.getBoolean(USE_DEPRECATED_LAUNCH_KEY, false)
        }

        fun getRenderedDisplayNameOption(): String? = sharedPrefs.getString(RENDERED_DISPLAY_NAME, null)

        fun getAvatarImageOption(): String? = sharedPrefs.getString(AVATAR_IMAGE, null)

        fun getTitle(): String? = sharedPrefs.getString(CALL_TITLE, null)

        fun getSubtitle(): String? = sharedPrefs.getString(CALL_SUBTITLE, null)

        fun callScreenOrientation(): String? =
            sharedPrefs.getString(
                CALL_SCREEN_ORIENTATION_SHARED_PREF_KEY,
                null,
            )

        fun telecomManagerIntegration(): String? =
            sharedPrefs.getString(
                TELECOM_MANAGER_INTEGRATION_OPTION_KEY,
                null,
            )

        fun setupScreenOrientation(): String? =
            sharedPrefs.getString(
                SETUP_SCREEN_ORIENTATION_SHARED_PREF_KEY,
                null,
            )

        fun enableMultitasking(): Boolean? {
            return if (sharedPrefs.contains(ENABLE_MULTITASKING)) {
                sharedPrefs.getBoolean(ENABLE_MULTITASKING, ENABLE_MULTITASKING_DEFAULT_VALUE)
            } else {
                null
            }
        }

        fun enablePipWhenMultitasking(): Boolean? {
            return if (sharedPrefs.contains(ENABLE_PIP_WHEN_MULTITASKING)) {
                sharedPrefs.getBoolean(ENABLE_PIP_WHEN_MULTITASKING, ENABLE_PIP_WHEN_MULTITASKING_DEFAULT_VALUE)
            } else {
                null
            }
        }

        fun getDisplayLeaveCallConfirmationValue(): Boolean? {
            return if (sharedPrefs.contains(DISPLAY_LEAVE_CALL_CONFIRMATION_VALUE)) {
                sharedPrefs.getBoolean(
                    DISPLAY_LEAVE_CALL_CONFIRMATION_VALUE,
                    DEFAULT_DISPLAY_LEAVE_CALL_CONFIRMATION_VALUE
                )
            } else {
                null
            }
        }

        fun getSetupScreenCameraEnabledValue(): Boolean? {
            return if (sharedPrefs.contains(SETUP_SCREEN_CAMERA_ENABLED)) {
                sharedPrefs.getBoolean(
                    SETUP_SCREEN_CAMERA_ENABLED,
                    DEFAULT_SETUP_SCREEN_CAMERA_ENABLED_VALUE
                )
            } else {
                null
            }
        }

        fun getSetupScreenMicEnabledValue(): Boolean? {
            return if (sharedPrefs.contains(SETUP_SCREEN_MIC_ENABLED)) {
                sharedPrefs.getBoolean(
                    SETUP_SCREEN_MIC_ENABLED,
                    DEFAULT_SETUP_SCREEN_MIC_ENABLED_VALUE
                )
            } else {
                null
            }
        }

        fun getAutoStartCaptionsEnabled(): Boolean? {
            return if (sharedPrefs.contains(AUTO_START_CAPTIONS)) {
                sharedPrefs.getBoolean(
                    AUTO_START_CAPTIONS,
                    DEFAULT_AUTO_START_CAPTIONS
                )
            } else {
                null
            }
        }

        fun getHideCaptionsUiEnabled(): Boolean? {
            return if (sharedPrefs.contains(HIDE_CAPTIONS_UI)) {
                sharedPrefs.getBoolean(
                    HIDE_CAPTIONS_UI,
                    DEFAULT_HIDE_CAPTIONS_UI
                )
            } else {
                null
            }
        }

        fun getAddCustomButtons(): Boolean? {
            return if (sharedPrefs.contains(ADD_CUSTOM_BUTTONS_KEY)) {
                sharedPrefs.getBoolean(
                    ADD_CUSTOM_BUTTONS_KEY,
                    DEFAULT_ADD_CUSTOM_BUTTONS
                )
            } else {
                null
            }
        }
    }
}