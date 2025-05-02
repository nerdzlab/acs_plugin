// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.action

import com.acs_plugin.calling.redux.state.PermissionStatus

internal sealed class PermissionAction :
    Action {
    class AudioPermissionRequested : PermissionAction()
    class CameraPermissionRequested : PermissionAction()
    class AudioPermissionIsSet(val permissionState: PermissionStatus) : PermissionAction()
    class CameraPermissionIsSet(val permissionState: PermissionStatus) : PermissionAction()
}
