// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models;

import com.acs_plugin.calling.CallComposite;

/**
 * Setup screen options to provide for {@link CallComposite}.
 */
public final class CallCompositeSetupScreenOptions {

    private Boolean cameraButtonEnabled = null;
    private Boolean micButtonEnabled = null;
    private Boolean cameraSwitchButtonEnabled = null;
    private Boolean blurButtonEnabled = null;

    private CallCompositeButtonViewData cameraButton;
    private CallCompositeButtonViewData micButton;
    private CallCompositeButtonViewData audioDeviceButton;
    private CallCompositeButtonViewData blurButton;
    private CallCompositeButtonViewData cameraSwitchButton;

    /**
     * Creates {@link CallCompositeSetupScreenOptions}.
     */
    public CallCompositeSetupScreenOptions() {
    }

    /**
     * @deprecated Use {@link #setCameraButton(CallCompositeButtonViewData)} instead.
     * Set camera button enabled to user. Enabled by default.
     * @param enabled Sets camera button enable/disabled on the setup screen.
     * @return {@link CallCompositeSetupScreenOptions}.
     */
    @Deprecated
    public CallCompositeSetupScreenOptions setCameraButtonEnabled(final Boolean enabled) {
        this.cameraButtonEnabled = enabled;
        return this;
    }

    /**
     * @deprecated Use {@link #setCameraButton(CallCompositeButtonViewData)} instead.
     * Is camera button enabled to user.
     */
    @Deprecated
    public Boolean isCameraButtonEnabled() {
        return this.cameraButtonEnabled;
    }

    /**
     * @deprecated Use {@link #setMicrophoneButton(CallCompositeButtonViewData)} instead.
     * Set microphone button enabled to user. Enabled by default.
     * @param enabled Sets microphone button enable/disabled on the setup screen.
     * @return {@link CallCompositeSetupScreenOptions}.
     */
    @Deprecated
    public CallCompositeSetupScreenOptions setMicrophoneButtonEnabled(final Boolean enabled) {
        this.micButtonEnabled = enabled;
        return this;
    }

    /**
     * @deprecated Use {@link #setMicrophoneButton(CallCompositeButtonViewData)} instead.
     * Is microphone button enabled to user.
     */
    @Deprecated
    public Boolean isMicrophoneButtonEnabled() {
        return this.micButtonEnabled;
    }

    /**
     * Set blur button enabled on the setup screen.
     * @param enabled true if the blur button should be enabled.
     * @return This CallCompositeSetupScreenOptions instance.
     */
    public CallCompositeSetupScreenOptions setBlurButtonEnabled(final Boolean enabled) {
        this.blurButtonEnabled = enabled;
        return this;
    }

    /**
     * Check if blur button is enabled on the setup screen.
     * @return true if enabled, false otherwise.
     */
    public Boolean isBlurButtonEnabled() {
        return this.blurButtonEnabled;
    }

    /**
     * Set camera switch button enabled on the setup screen.
     * @param enabled true if the camera switch button should be enabled.
     * @return This CallCompositeSetupScreenOptions instance.
     */
    public CallCompositeSetupScreenOptions setCameraSwitchButtonEnabled(final Boolean enabled) {
        this.cameraSwitchButtonEnabled = enabled;
        return this;
    }

    /**
     * Check if camera switch button is enabled on the setup screen.
     * @return true if enabled, false otherwise.
     */
    public Boolean isCameraSwitchButtonEnabled() {
        return this.cameraSwitchButtonEnabled;
    }

    /**
     * Set customization to the camera button.
     * @param buttonOptions {@link CallCompositeButtonViewData}
     */
    public CallCompositeSetupScreenOptions setCameraButton(final CallCompositeButtonViewData buttonOptions) {
        this.cameraButton = buttonOptions;
        return this;
    }

    /**
     * Get customization to the camera button.
     */
    public CallCompositeButtonViewData getCameraButton() {
        return this.cameraButton;
    }

    /**
     * Set customization to the microphone button.
     * @param buttonOptions {@link CallCompositeButtonViewData}
     */
    public CallCompositeSetupScreenOptions setMicrophoneButton(
            final CallCompositeButtonViewData buttonOptions) {
        micButton = buttonOptions;
        return this;
    }

    /**
     * Get customization of the microphone button.
     */
    public CallCompositeButtonViewData getMicrophoneButton() {
        return micButton;
    }

    /**
     * Set customization to the audio device button.
     * @param buttonOptions {@link CallCompositeButtonViewData}
     */
    public CallCompositeSetupScreenOptions setAudioDeviceButton(
            final CallCompositeButtonViewData buttonOptions) {
        audioDeviceButton = buttonOptions;
        return this;
    }

    /**
     * Get customization of the audio device button.
     */
    public CallCompositeButtonViewData getAudioDeviceButton() {
        return audioDeviceButton;
    }

    /**
     * Sets the blur button on the setup screen.
     * @param button The button configuration.
     * @return This CallCompositeSetupScreenOptions instance.
     */
    public CallCompositeSetupScreenOptions setBlurButton(final CallCompositeButtonViewData button) {
        this.blurButton = button;
        return this;
    }

    /**
     * Gets the blur button on the setup screen.
     * @return The blur button configuration.
     */
    public CallCompositeButtonViewData getBlurButton() {
        return this.blurButton;
    }

    /**
     * Sets the camera switch button on the setup screen.
     * @param button The button configuration.
     * @return This CallCompositeSetupScreenOptions instance.
     */
    public CallCompositeSetupScreenOptions setCameraSwitchButton(final CallCompositeButtonViewData button) {
        this.cameraSwitchButton = button;
        return this;
    }

    /**
     * Gets the camera switch button on the setup screen.
     * @return The camera switch button configuration.
     */
    public CallCompositeButtonViewData getCameraSwitchButton() {
        return this.cameraSwitchButton;
    }
}
