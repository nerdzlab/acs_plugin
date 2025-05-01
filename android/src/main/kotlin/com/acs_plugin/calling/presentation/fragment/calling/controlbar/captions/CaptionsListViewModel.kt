// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.controlbar.captions

import android.content.Context
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.models.CallCompositeButtonViewData
import com.acs_plugin.calling.models.createButtonClickEvent
import com.acs_plugin.calling.redux.Dispatch
import com.acs_plugin.calling.redux.action.CaptionsAction
import com.acs_plugin.calling.redux.action.NavigationAction
import com.acs_plugin.calling.redux.action.RttAction
import com.acs_plugin.calling.redux.state.ButtonState
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.CaptionsState
import com.acs_plugin.calling.redux.state.CaptionsStatus
import com.acs_plugin.calling.redux.state.NavigationState
import com.acs_plugin.calling.redux.state.RttState
import com.acs_plugin.calling.redux.state.VisibilityState
import com.acs_plugin.calling.redux.state.VisibilityStatus
import kotlinx.coroutines.flow.MutableStateFlow

internal class CaptionsListViewModel(
    private val dispatch: Dispatch,
    val liveCaptionsToggleButton: CallCompositeButtonViewData?,
    val spokenLanguageButton: CallCompositeButtonViewData?,
    val captionsLanguageButton: CallCompositeButtonViewData?,
    private val logger: Logger,

) {

    val displayStateFlow = MutableStateFlow(false)
    val activeSpokenLanguageStateFlow = MutableStateFlow<String?>(null)
    val activeCaptionLanguageStateFlow = MutableStateFlow<String?>(null)
    val isCaptionsEnabledStateFlow = MutableStateFlow(false)
    val isCaptionsLangButtonVisibleStateFlow = MutableStateFlow(false)
    val isCaptionsLangButtonEnabledStateFlow = MutableStateFlow(false)
    val isCaptionsActiveStateFlow = MutableStateFlow(false)
    val isCaptionsToggleEnabledStateFlow = MutableStateFlow(false)
    val isCaptionsToggleVisibleStateFlow = MutableStateFlow(false)
    val isRttButtonEnabledStateFlow = MutableStateFlow(false)

    val isSpokenLanguageButtonVisibleStateFlow = MutableStateFlow(false)
    val isSpokenLanguageButtonEnabledStateFlow = MutableStateFlow(false)

    fun init(
        captionsState: CaptionsState,
        callingStatus: CallingStatus,
        visibilityState: VisibilityState,
        buttonState: ButtonState,
        rttState: RttState,
        navigationState: NavigationState,
    ) =
        updateListView(captionsState, callingStatus, visibilityState.status, buttonState, rttState, navigationState)

    fun update(
        captionsState: CaptionsState,
        callingStatus: CallingStatus,
        visibilityState: VisibilityState,
        buttonState: ButtonState,
        rttState: RttState,
        navigationState: NavigationState,
    ) =
        updateListView(captionsState, callingStatus, visibilityState.status, buttonState, rttState, navigationState)

    private fun updateListView(
        captionsState: CaptionsState,
        callingStatus: CallingStatus,
        visibilityStatus: VisibilityStatus,
        buttonState: ButtonState,
        rttState: RttState,
        navigationState: NavigationState,
    ) {
        activeCaptionLanguageStateFlow.value = captionsState.captionLanguage
        activeSpokenLanguageStateFlow.value = captionsState.spokenLanguage
        isCaptionsEnabledStateFlow.value = captionsState.isCaptionsUIEnabled
        isCaptionsLangButtonVisibleStateFlow.value = shouldCaptionsLangButtonBeVisible(captionsState, buttonState)
        isCaptionsLangButtonEnabledStateFlow.value = shouldCaptionsLangButtonBeEnabled(captionsState, buttonState)
        isCaptionsActiveStateFlow.value = captionsState.status == CaptionsStatus.STARTED
        isCaptionsToggleEnabledStateFlow.value = shouldCaptionsToggleBeEnabled(callingStatus, buttonState)
        isCaptionsToggleVisibleStateFlow.value = shouldCaptionsToggleBeVisible(buttonState)

        isSpokenLanguageButtonVisibleStateFlow.value = shouldSpokenLanguageButtonBeVisible(buttonState)
        isSpokenLanguageButtonEnabledStateFlow.value = shouldSpokenLanguageButtonBeEnabled(captionsState, buttonState)

        displayStateFlow.value = navigationState.showCaptionsToggleUI && visibilityStatus == VisibilityStatus.VISIBLE

        isRttButtonEnabledStateFlow.value = !rttState.isRttActive

        logger.debug("CaptionsListViewModel isCaptionsActiveStateFlow: ${isCaptionsActiveStateFlow.value}")
    }

    fun close() {
        dispatch(NavigationAction.CloseCaptionsOptions())
    }

    fun back() {
        dispatch(NavigationAction.CloseCaptionsOptions())
        dispatch(NavigationAction.ShowMoreMenu())
    }

    fun toggleCaptions(context: Context, isChecked: Boolean) {
        if (!isChecked) {
            dispatch(CaptionsAction.StopRequested())
            close()
        } else {
            dispatch(CaptionsAction.StartRequested(activeSpokenLanguageStateFlow.value))
        }
        callButtonCustomOnClick(context, liveCaptionsToggleButton)
    }

    fun openCaptionLanguageSelection(context: Context) {
        dispatch(NavigationAction.ShowSupportedCaptionLanguagesOptions())
        close()
        callButtonCustomOnClick(context, captionsLanguageButton)
    }

    fun openSpokenLanguageSelection(context: Context) {
        dispatch(NavigationAction.ShowSupportedSpokenLanguagesOptions())
        close()
        callButtonCustomOnClick(context, spokenLanguageButton)
    }

    fun enableRTT() {
        dispatch(RttAction.EnableRtt())
        dispatch(RttAction.UpdateMaximized(true))
        close()
    }

    private fun shouldCaptionsToggleBeEnabled(
        callingStatus: CallingStatus,
        buttonState: ButtonState
    ): Boolean {
        return callingStatus == CallingStatus.CONNECTED && buttonState.liveCaptionsToggleButton?.isEnabled ?: true
    }

    private fun shouldCaptionsToggleBeVisible(
        buttonState: ButtonState
    ): Boolean {
        return buttonState.liveCaptionsToggleButton?.isVisible ?: true
    }

    private fun callButtonCustomOnClick(context: Context, button: CallCompositeButtonViewData?) {
        try {
            button?.onClickHandler?.handle(
                createButtonClickEvent(context, button)
            )
        } catch (e: Exception) {
            logger.error("Call screen control bar button custom onClick exception.", e)
        }
    }

    private fun shouldSpokenLanguageButtonBeVisible(
        buttonState: ButtonState,
    ): Boolean {
        return buttonState.spokenLanguageButton?.isVisible ?: true
    }

    private fun shouldSpokenLanguageButtonBeEnabled(
        captionsState: CaptionsState,
        buttonState: ButtonState,
    ): Boolean {
        return captionsState.status == CaptionsStatus.STARTED &&
            buttonState.spokenLanguageButton?.isEnabled ?: true
    }

    private fun shouldCaptionsLangButtonBeVisible(
        captionsState: CaptionsState,
        buttonState: ButtonState,
    ): Boolean {
        return captionsState.isTranslationSupported &&
            buttonState.captionsLanguageButton?.isVisible ?: true
    }

    private fun shouldCaptionsLangButtonBeEnabled(
        captionsState: CaptionsState,
        buttonState: ButtonState,
    ): Boolean {
        return captionsState.status == CaptionsStatus.STARTED &&
            buttonState.captionsLanguageButton?.isEnabled ?: true
    }
}
