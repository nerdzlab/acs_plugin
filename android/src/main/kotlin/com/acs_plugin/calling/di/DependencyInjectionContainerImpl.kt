// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.di

import android.content.Context
import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.data.CallHistoryRepositoryImpl
import com.acs_plugin.calling.error.ErrorHandler
import com.acs_plugin.calling.getCallingSDKInitializer
import com.acs_plugin.calling.getConfig
import com.acs_plugin.calling.handlers.CallStateHandler
import com.acs_plugin.calling.handlers.RemoteParticipantHandler
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.models.CallCompositeAudioVideoMode
import com.acs_plugin.calling.presentation.CallCompositeActivity
import com.acs_plugin.calling.presentation.VideoStreamRendererFactory
import com.acs_plugin.calling.presentation.VideoStreamRendererFactoryImpl
import com.acs_plugin.calling.presentation.VideoViewManager
import com.acs_plugin.calling.presentation.manager.AccessibilityAnnouncementManager
import com.acs_plugin.calling.presentation.manager.AudioFocusManager
import com.acs_plugin.calling.presentation.manager.AudioModeManager
import com.acs_plugin.calling.presentation.manager.AudioSessionManager
import com.acs_plugin.calling.presentation.manager.AvatarViewManager
import com.acs_plugin.calling.presentation.manager.CameraStatusHook
import com.acs_plugin.calling.presentation.manager.CapabilitiesManager
import com.acs_plugin.calling.presentation.manager.CaptionsRttDataManager
import com.acs_plugin.calling.presentation.manager.CaptionsStatusHook
import com.acs_plugin.calling.presentation.manager.CompositeExitManager
import com.acs_plugin.calling.presentation.manager.DebugInfoManager
import com.acs_plugin.calling.presentation.manager.DebugInfoManagerImpl
import com.acs_plugin.calling.presentation.manager.LifecycleManagerImpl
import com.acs_plugin.calling.presentation.manager.MeetingJoinedHook
import com.acs_plugin.calling.presentation.manager.MultitaskingManager
import com.acs_plugin.calling.presentation.manager.NetworkManager
import com.acs_plugin.calling.presentation.manager.NotificationStatusHook
import com.acs_plugin.calling.presentation.manager.ParticipantAddedOrRemovedHook
import com.acs_plugin.calling.presentation.manager.PermissionManager
import com.acs_plugin.calling.presentation.manager.SwitchCameraStatusHook
import com.acs_plugin.calling.presentation.manager.UpdatableOptionsManager
import com.acs_plugin.calling.presentation.navigation.NavigationRouterImpl
import com.acs_plugin.calling.redux.AppStore
import com.acs_plugin.calling.redux.Middleware
import com.acs_plugin.calling.redux.middleware.CallingMiddlewareImpl
import com.acs_plugin.calling.redux.middleware.handler.CallingMiddlewareActionHandlerImpl
import com.acs_plugin.calling.redux.reducer.AppStateReducer
import com.acs_plugin.calling.redux.reducer.AudioSessionStateReducerImpl
import com.acs_plugin.calling.redux.reducer.ButtonViewDataReducerImpl
import com.acs_plugin.calling.redux.reducer.CallDiagnosticsReducerImpl
import com.acs_plugin.calling.redux.reducer.CallScreenInformationHeaderReducerImpl
import com.acs_plugin.calling.redux.reducer.CallStateReducerImpl
import com.acs_plugin.calling.redux.reducer.CaptionsReducerImpl
import com.acs_plugin.calling.redux.reducer.DeviceConfigurationReducerImpl
import com.acs_plugin.calling.redux.reducer.ErrorReducerImpl
import com.acs_plugin.calling.redux.reducer.LifecycleReducerImpl
import com.acs_plugin.calling.redux.reducer.LocalParticipantStateReducerImpl
import com.acs_plugin.calling.redux.reducer.NavigationReducerImpl
import com.acs_plugin.calling.redux.reducer.ParticipantStateReducerImpl
import com.acs_plugin.calling.redux.reducer.PermissionStateReducerImpl
import com.acs_plugin.calling.redux.reducer.PipReducerImpl
import com.acs_plugin.calling.redux.reducer.Reducer
import com.acs_plugin.calling.redux.reducer.RttReducerImpl
import com.acs_plugin.calling.redux.reducer.ToastNotificationReducerImpl
import com.acs_plugin.calling.redux.state.AppReduxState
import com.acs_plugin.calling.redux.state.ReduxState
import com.acs_plugin.calling.service.CallHistoryService
import com.acs_plugin.calling.service.CallHistoryServiceImpl
import com.acs_plugin.calling.service.CallingService
import com.acs_plugin.calling.service.NotificationService
import com.acs_plugin.calling.service.sdk.CallingSDK
import com.acs_plugin.calling.service.sdk.CallingSDKEventHandler
import com.acs_plugin.calling.service.sdk.CallingSDKWrapper
import com.acs_plugin.calling.utilities.CoroutineContextProvider
import java.lang.ref.WeakReference

internal class DependencyInjectionContainerImpl(
    private val instanceId: Int,
    private val parentContext: Context,
    override val callComposite: CallComposite,
    private val customCallingSDK: CallingSDK?,
    private val customVideoStreamRendererFactory: VideoStreamRendererFactory?,
    private val customCoroutineContextProvider: CoroutineContextProvider?,
    private val defaultLogger: Logger
) : DependencyInjectionContainer {
    private val callingSDKInitializer by lazy {
        callComposite.getCallingSDKInitializer()
    }

    override var callCompositeActivityWeakReference: WeakReference<CallCompositeActivity> = WeakReference(null)

    override val configuration by lazy {
        callComposite.getConfig()
    }

    override val captionsRttDataManager by lazy {
        CaptionsRttDataManager(
            callingService,
            appStore,
            avatarViewManager,
            configuration.localUserIdentifier,
            configuration.displayName,
        )
    }

    override val navigationRouter by lazy {
        NavigationRouterImpl(appStore)
    }

    override val callingMiddlewareActionHandler by lazy {
        CallingMiddlewareActionHandlerImpl(
            callingService,
            coroutineContextProvider,
            configuration,
            capabilitiesManager,
            localOptions = configuration.callCompositeLocalOptions
        )
    }

    override val callStateHandler by lazy {
        CallStateHandler(configuration, appStore)
    }

    override val errorHandler by lazy {
        ErrorHandler(configuration, appStore)
    }

    override val updatableOptionsManager by lazy {
        UpdatableOptionsManager(
            configuration,
            appStore,
        )
    }

    override val videoViewManager by lazy {
        VideoViewManager(
            callingSDKWrapper,
            applicationContext,
            customVideoStreamRendererFactory ?: VideoStreamRendererFactoryImpl()
        )
    }

    override val compositeExitManager by lazy {
        CompositeExitManager(appStore, configuration)
    }

    override val permissionManager by lazy {
        PermissionManager(appStore)
    }

    override val audioSessionManager by lazy {
        AudioSessionManager(
            appStore,
            applicationContext,
            /*  <DEFAULT_AUDIO_MODE:0>
            configuration.audioSelectionMode
            </DEFAULT_AUDIO_MODE:0> */
        )
    }

    override val audioFocusManager by lazy {
        AudioFocusManager(
            appStore,
            applicationContext,
            configuration.telecomManagerOptions
        )
    }

    override val audioModeManager by lazy {
        AudioModeManager(
            appStore,
            applicationContext,
        )
    }

    override val networkManager by lazy {
        NetworkManager(
            applicationContext,
        )
    }

    override val debugInfoManager: DebugInfoManager by lazy {
        DebugInfoManagerImpl(
            callHistoryRepository,
            getLogFiles = callingService::getLogFiles,
        )
    }

    override val callHistoryService: CallHistoryService by lazy {
        CallHistoryServiceImpl(
            appStore,
            callHistoryRepository
        )
    }

    override val avatarViewManager by lazy {
        AvatarViewManager(
            coroutineContextProvider,
            appStore,
            configuration.callCompositeLocalOptions,
            configuration.remoteParticipantsConfiguration
        )
    }

    override val accessibilityManager by lazy {
        AccessibilityAnnouncementManager(
            appStore,
            listOf(
                MeetingJoinedHook(),
                CameraStatusHook(),
                ParticipantAddedOrRemovedHook(),
                SwitchCameraStatusHook(),
                CaptionsStatusHook(),
                NotificationStatusHook(),
            )
        )
    }

    override val lifecycleManager by lazy {
        LifecycleManagerImpl(appStore)
    }

    override val multitaskingManager by lazy {
        MultitaskingManager(appStore, configuration)
    }

    override val appStore by lazy {
        AppStore(
            initialState,
            appReduxStateReducer,
            appMiddleware,
            storeDispatcher
        )
    }

    override val notificationService by lazy {
        NotificationService(parentContext, appStore, configuration, instanceId)
    }

    override val remoteParticipantHandler by lazy {
        RemoteParticipantHandler(configuration, appStore, callingSDKWrapper)
    }

    override val callHistoryRepository by lazy {
        CallHistoryRepositoryImpl(applicationContext, logger)
    }

    override val capabilitiesManager by lazy {
        CapabilitiesManager(
            configuration.callConfig.callType,
        )
    }

    private val localOptions by lazy {
        configuration.callCompositeLocalOptions
    }

    //region Redux
    // Initial State
    private val initialState by lazy {
        configuration.callCompositeLocalOptions

        AppReduxState(
            displayName = configuration.displayName,
            cameraOnByDefault = localOptions?.isCameraOn ?: false,
            microphoneOnByDefault = localOptions?.isMicrophoneOn ?: false,
            avMode = localOptions?.audioVideoMode ?: CallCompositeAudioVideoMode.AUDIO_AND_VIDEO,
            skipSetupScreen = localOptions?.isSkipSetupScreen ?: false,
            showCaptionsUI = true,
            localOptions = configuration.callCompositeLocalOptions
        )
    }

    // Reducers
    private val callStateReducer get() = CallStateReducerImpl()
    private val participantStateReducer = ParticipantStateReducerImpl()
    private val localParticipantStateReducer get() = LocalParticipantStateReducerImpl()
    private val permissionStateReducer get() = PermissionStateReducerImpl()
    private val lifecycleReducer get() = LifecycleReducerImpl()
    private val errorReducer get() = ErrorReducerImpl()
    private val navigationReducer get() = NavigationReducerImpl()
    private val audioSessionReducer get() = AudioSessionStateReducerImpl()
    private val pipReducer get() = PipReducerImpl()
    private val callDiagnosticsReducer get() = CallDiagnosticsReducerImpl()
    private val toastNotificationReducer get() = ToastNotificationReducerImpl()
    private val captionsReducer get() = CaptionsReducerImpl()
    private val callScreenInformationHeaderReducer get() = CallScreenInformationHeaderReducerImpl()
    private val buttonOptionsReducer get() = ButtonViewDataReducerImpl()

    private val rttReducer get() = RttReducerImpl()
    private val softwareKeyboardReducer get() = DeviceConfigurationReducerImpl()

    // Middleware
    private val appMiddleware get() = mutableListOf(callingMiddleware)

    private val callingMiddleware: Middleware<ReduxState> by lazy {
        CallingMiddlewareImpl(
            callingMiddlewareActionHandler,
            logger
        )
    }

    private val appReduxStateReducer: Reducer<ReduxState> by lazy {
        AppStateReducer(
            callStateReducer,
            participantStateReducer,
            localParticipantStateReducer,
            permissionStateReducer,
            lifecycleReducer,
            errorReducer,
            navigationReducer,
            audioSessionReducer,
            pipReducer,
            callDiagnosticsReducer,
            toastNotificationReducer,
            captionsReducer,
            /* CUSTOM_CALL_HEADER */
            callScreenInformationHeaderReducer,
            /* CUSTOM_CALL_HEADER */
            buttonOptionsReducer,
            rttReducer,
            softwareKeyboardReducer,
        ) as Reducer<ReduxState>
    }
    //endregion

    //region System
    private val applicationContext get() = parentContext.applicationContext

    override val logger: Logger by lazy { defaultLogger }

    private val callingSDKWrapper: CallingSDK by lazy {
        customCallingSDK
            ?: CallingSDKWrapper(
                applicationContext,
                callingSDKEventHandler,
                configuration.callConfig,
                logger,
                callingSDKInitializer,
                compositeCaptionsOptions = localOptions?.captionsOptions,
                configuration.localUserIdentifier?.rawId
                /* <END_CALL_FOR_ALL>
                isOnCallEndTerminateForAll = localOptions?.isOnCallEndTerminateForAll ?: false
                </END_CALL_FOR_ALL> */
            )
    }

    private val callingSDKEventHandler by lazy {
        CallingSDKEventHandler(
            coroutineContextProvider,
            localOptions?.audioVideoMode ?: CallCompositeAudioVideoMode.AUDIO_AND_VIDEO,
        )
    }

    override val callingService by lazy {
        CallingService(callingSDKWrapper, coroutineContextProvider)
    }
    //endregion

    //region Threading
    private val coroutineContextProvider by lazy {
        customCoroutineContextProvider ?: CoroutineContextProvider()
    }
    private val storeDispatcher by lazy {
        customCoroutineContextProvider?.SingleThreaded ?: coroutineContextProvider.SingleThreaded
    }
    //endregion
}
