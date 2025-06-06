/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License.
 */

package com.acs_plugin.chat.models

import android.content.Context
import androidx.annotation.DrawableRes
import androidx.annotation.StringRes
import com.acs_plugin.chat.redux.action.Action

internal data class MenuItemModel(
    @StringRes val title: Int,
    @DrawableRes val icon: Int,
    val action: Action? = null,
    var onClickAction: ((context: Context) -> Unit)? = null,
)
