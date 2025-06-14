// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.


package com.acs_plugin.chat.models;

import com.acs_plugin.chat.ChatAdapter;

import java.util.Locale;

/**
 * Localization configuration to provide for {@link ChatAdapter}.
 *
 * @see ChatAdapter
 */
final class ChatCompositeLocalizationOptions {
    private final Locale locale;
    private Integer layoutDirection;

    /**
     * Create Localization configuration.
     *
     * @param locale The {@link Locale}; eg,. {@code Locale.US}
     */
    ChatCompositeLocalizationOptions(final Locale locale) {
        this.locale = locale;
    }

    /**
     * Create Localization configuration.
     *
     * @param locale          The {@link Locale}; eg,. {@code Locale.US}
     * @param layoutDirection layout direction int; eg,. {@code LayoutDirection.RTL}
     */
    ChatCompositeLocalizationOptions(final Locale locale, final int layoutDirection) {
        this.locale = locale;
        this.layoutDirection = layoutDirection;
    }

    /**
     * Get current {@link Locale}.
     *
     * @return The {@link Locale}.
     */
    public Locale getLocale() {
        return locale;
    }

    /**
     * Get layoutDirection {@link Integer}.
     *
     * @return layoutDirection {@link Integer}.
     */
    public Integer getLayoutDirection() {
        return layoutDirection;
    }
}
