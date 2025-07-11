package com.acs_plugin.calling.presentation.manager

import com.acs_plugin.calling.configuration.CallCompositeConfiguration
import com.acs_plugin.calling.models.CallCompositeCustomButtonViewData
import com.acs_plugin.calling.models.setDrawableIdChangedEventHandler
import com.acs_plugin.calling.models.setEnabledChangedEventHandler
/* <CALL_START_TIME>
import com.acs_plugin.calling.models.setShowCallDurationChangedEventHandler
</CALL_START_TIME> */
import com.acs_plugin.calling.models.setSubtitleChangedEventHandler
import com.acs_plugin.calling.models.setTitleChangedEventHandler
import com.acs_plugin.calling.models.setVisibleChangedEventHandler
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.action.ButtonViewDataAction
import com.acs_plugin.calling.redux.action.CallScreenInfoHeaderAction
import com.acs_plugin.calling.redux.state.ReduxState

internal class UpdatableOptionsManager(
    private val configuration: CallCompositeConfiguration,
    private val store: Store<ReduxState>,
) {
    fun start() {
        configuration.callScreenOptions?.headerViewData?.run {
            setTitleChangedEventHandler {
                store.dispatch(CallScreenInfoHeaderAction.UpdateTitle(it))
            }
            setSubtitleChangedEventHandler {
                store.dispatch(CallScreenInfoHeaderAction.UpdateSubtitle(it))
            }
            /* <CALL_START_TIME>
            setShowCallDurationChangedEventHandler {
                store.dispatch(CallScreenInfoHeaderAction.UpdateShowCallDuration(it ?: true))
            }
            </CALL_START_TIME> */
        }
        configuration.callScreenOptions?.controlBarOptions?.run {
            cameraButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenCameraButtonIsEnabledUpdated(it))
            }
            cameraButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenCameraButtonIsVisibleUpdated(it))
            }
            microphoneButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenMicButtonIsEnabledUpdated(it))
            }
            microphoneButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenMicButtonIsVisibleUpdated(it))
            }
            audioDeviceButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenAudioDeviceButtonIsEnabledUpdated(it))
            }
            audioDeviceButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenAudioDeviceButtonIsVisibleUpdated(it))
            }
            liveCaptionsButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenLiveCaptionsButtonIsEnabledUpdated(it))
            }
            liveCaptionsButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenLiveCaptionsButtonIsVisibleUpdated(it))
            }
            liveCaptionsToggleButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenLiveCaptionsToggleButtonIsEnabledUpdated(it))
            }
            liveCaptionsToggleButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenLiveCaptionsToggleButtonIsVisibleUpdated(it))
            }
            spokenLanguageButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenSpokenLanguageButtonIsEnabledUpdated(it))
            }
            spokenLanguageButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenSpokenLanguageButtonIsVisibleUpdated(it))
            }
            captionsLanguageButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenCaptionsLanguageButtonIsEnabledUpdated(it))
            }
            captionsLanguageButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenCaptionsLanguageButtonIsVisibleUpdated(it))
            }
            shareDiagnosticsButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenShareDiagnosticsButtonIsEnabledUpdated(it))
            }
            shareDiagnosticsButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenShareDiagnosticsButtonIsVisibleUpdated(it))
            }
            reportIssueButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenReportIssueButtonIsEnabledUpdated(it))
            }
            reportIssueButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.CallScreenReportIssueButtonIsVisibleUpdated(it))
            }

            customButtons?.forEach {
                it.setEnabledChangedEventHandler { isEnabled ->
                    store.dispatch(ButtonViewDataAction.CallScreenCustomButtonIsEnabledUpdated(it.id, isEnabled))
                }
                it.setVisibleChangedEventHandler { isVisible ->
                    store.dispatch(ButtonViewDataAction.CallScreenCustomButtonIsVisibleUpdated(it.id, isVisible))
                }
                it.setDrawableIdChangedEventHandler { drawableId ->
                    store.dispatch(ButtonViewDataAction.CallScreenCustomButtonIconUpdated(it.id, drawableId))
                }
            }
        }

        configuration.setupScreenOptions?.run {
            cameraButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenCameraButtonIsEnabledUpdated(it))
            }
            cameraButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenCameraButtonIsVisibleUpdated(it))
            }
            cameraSwitchButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenCameraSwitchButtonIsEnabledUpdated(it))
            }
            cameraSwitchButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenCameraSwitchButtonIsVisibleUpdated(it))
            }
            microphoneButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenMicButtonIsEnabledUpdated(it))
            }
            microphoneButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenMicButtonIsVisibleUpdated(it))
            }
            blurButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenBlurButtonIsEnabledUpdated(it))
            }
            blurButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenBlurButtonIsVisibleUpdated(it))
            }
            audioDeviceButton?.setEnabledChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenAudioDeviceButtonIsEnabledUpdated(it))
            }
            audioDeviceButton?.setVisibleChangedEventHandler {
                store.dispatch(ButtonViewDataAction.SetupScreenAudioDeviceButtonIsVisibleUpdated(it))
            }
        }

        configuration.callScreenOptions?.headerViewData?.customButtons?.forEach {
            it.setEnabledChangedEventHandler { isEnabled ->
                store.dispatch(ButtonViewDataAction.CallScreenHeaderCustomButtonIsEnabledUpdated(it.id, isEnabled))
            }
            it.setVisibleChangedEventHandler { isVisible ->
                store.dispatch(ButtonViewDataAction.CallScreenHeaderCustomButtonIsVisibleUpdated(it.id, isVisible))
            }
            it.setDrawableIdChangedEventHandler { drawableId ->
                store.dispatch(ButtonViewDataAction.CallScreenHeaderCustomButtonIconUpdated(it.id, drawableId))
            }
        }
    }

    fun getButton(id: String): CallCompositeCustomButtonViewData {
        configuration.callScreenOptions?.controlBarOptions?.customButtons
            ?.find { it.id == id }
            ?.let {
                return it
            }
        configuration.callScreenOptions?.headerViewData?.customButtons
            ?.find { it.id == id }
            ?.let {
                return it
            }
        throw IllegalArgumentException("Button with id $id not found")
    }
}
