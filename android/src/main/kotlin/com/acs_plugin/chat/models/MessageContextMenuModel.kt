/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License.
 */

package com.acs_plugin.chat.models

internal data class MessageContextMenuModel(
    val messageInfoModel: MessageInfoModel,
    val menuItems: List<MenuItemModel>,
)
