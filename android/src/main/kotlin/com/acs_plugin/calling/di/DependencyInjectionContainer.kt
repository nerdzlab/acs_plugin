// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.di

import com.acs_plugin.calling.CallComposite
import com.acs_plugin.calling.configuration.CallCompositeConfiguration
import com.acs_plugin.calling.data.CallHistoryRepository
import com.acs_plugin.calling.error.ErrorHandler
import com.acs_plugin.calling.handlers.CallStateHandler
import com.acs_plugin.calling.handlers.RemoteParticipantHandler
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.presentation.CallCompositeActivity
import com.acs_plugin.calling.presentation.VideoViewManager
import com.acs_plugin.calling.presentation.manager.AccessibilityAnnouncementManager
import com.acs_plugin.calling.presentation.manager.AudioFocusManager
import com.acs_plugin.calling.presentation.manager.AudioModeManager
import com.acs_plugin.calling.presentation.manager.AudioSessionManager
import com.acs_plugin.calling.presentation.manager.AvatarViewManager
import com.acs_plugin.calling.presentation.manager.CapabilitiesManager
import com.acs_plugin.calling.presentation.manager.CaptionsRttDataManager
import com.acs_plugin.calling.presentation.manager.CompositeExitManager
import com.acs_plugin.calling.presentation.manager.DebugInfoManager
import com.acs_plugin.calling.presentation.manager.LifecycleManager
import com.acs_plugin.calling.presentation.manager.MultitaskingManager
import com.acs_plugin.calling.presentation.manager.NetworkManager
import com.acs_plugin.calling.presentation.manager.PermissionManager
import com.acs_plugin.calling.presentation.manager.UpdatableOptionsManager
import com.acs_plugin.calling.presentation.navigation.NavigationRouter
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.middleware.handler.CallingMiddlewareActionHandler
import com.acs_plugin.calling.redux.state.ReduxState
import com.acs_plugin.calling.service.CallHistoryService
import com.acs_plugin.calling.service.CallingService
import com.acs_plugin.calling.service.NotificationService
import com.acs_plugin.calling.service.sdk.CallingSDK
import java.lang.ref.WeakReference

// Dependency Container for the Call Composite Activity
// For implementation
// @see: {@link DependencyInjectionContainerImpl}
internal interface DependencyInjectionContainer {
    val logger: Logger

    // Redux Store
    val appStore: Store<ReduxState>
    val callingMiddlewareActionHandler: CallingMiddlewareActionHandler

    val callComposite: CallComposite

    // Config
    val configuration: CallCompositeConfiguration
    val errorHandler: ErrorHandler
    val remoteParticipantHandler: RemoteParticipantHandler
    val callStateHandler: CallStateHandler

    // System
    val permissionManager: PermissionManager
    val avatarViewManager: AvatarViewManager
    val audioSessionManager: AudioSessionManager
    val accessibilityManager: AccessibilityAnnouncementManager
    val lifecycleManager: LifecycleManager
    val multitaskingManager: MultitaskingManager
    val compositeExitManager: CompositeExitManager
    val navigationRouter: NavigationRouter
    val notificationService: NotificationService
    val audioFocusManager: AudioFocusManager
    val networkManager: NetworkManager
    val debugInfoManager: DebugInfoManager
    val callHistoryService: CallHistoryService
    val audioModeManager: AudioModeManager

    // UI
    val videoViewManager: VideoViewManager

    // Data
    val callHistoryRepository: CallHistoryRepository

    // Calling Service
    val callingService: CallingService

    // Added for Screenshot ability.
    //
    // To poke across contexts to do. (CallComposite Contoso Host -> CallCompositeActivity)
    // This isn't generally encouraged, but CallCompositeActivity context is needed for screenshot.
    var callCompositeActivityWeakReference: WeakReference<CallCompositeActivity>

    val capabilitiesManager: CapabilitiesManager
    val captionsRttDataManager: CaptionsRttDataManager

    val updatableOptionsManager: UpdatableOptionsManager
    val callingSDKWrapper: CallingSDK
}
