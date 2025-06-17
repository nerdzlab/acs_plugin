package com.acs_plugin.calling.presentation.fragment.common.audiodevicelist

import android.annotation.SuppressLint
import android.content.Context
import android.widget.FrameLayout
import android.widget.Switch
import androidx.appcompat.widget.LinearLayoutCompat
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.acs_plugin.R
import com.acs_plugin.calling.redux.state.AudioDeviceSelectionStatus
import com.acs_plugin.calling.redux.state.AudioState
import com.acs_plugin.calling.redux.state.NoiseSuppressionStatus
import com.acs_plugin.calling.utilities.BottomCellAdapter
import com.acs_plugin.calling.utilities.BottomCellItem
import com.acs_plugin.calling.utilities.isAndroidTV
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.microsoft.fluentui.R as fluentUiR
import kotlinx.coroutines.launch

@SuppressLint("ViewConstructor")
internal class AudioDeviceListView(
    private val viewModel: AudioDeviceListViewModel,
    context: Context,
) : LinearLayoutCompat(context) {

    private var deviceTable: RecyclerView
    private lateinit var audioDeviceDialog: BottomSheetDialog
    private lateinit var bottomCellAdapter: BottomCellAdapter
    private var noiseSuppressionSwitch: Switch

    init {
        inflate(context, R.layout.audio_device_list_view, this)
        deviceTable = findViewById(R.id.bottom_drawer_table)
        noiseSuppressionSwitch = findViewById(R.id.noise_suppression_switch)
        noiseSuppressionSwitch.setOnCheckedChangeListener { _, isChecked -> viewModel.switchNoiseSuppression(isChecked) }
    }

    fun start(viewLifecycleOwner: LifecycleOwner) {
        initializeAudioDeviceDialog()
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.audioStateFlow.collect {
                updateSelectedAudioDevice(it)
                updateNoiseSuppressionState(it)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.displayAudioDeviceSelectionMenuStateFlow.collect {
                if (it) {
                    showAudioDeviceSelectionMenu()
                }
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.audioStateFlow.collect {
                // / rebind the list of items
                bottomCellAdapter = BottomCellAdapter()
                bottomCellAdapter.setBottomCellItems(bottomCellItems)
                deviceTable.adapter = bottomCellAdapter
            }
        }
    }

    fun stop() {
        bottomCellAdapter.setBottomCellItems(mutableListOf())
        deviceTable.layoutManager = null
        audioDeviceDialog.dismiss()
        this.removeAllViews()
    }

    private fun showAudioDeviceSelectionMenu() {
        audioDeviceDialog.show()
    }

    private fun initializeAudioDeviceDialog() {
        audioDeviceDialog = BottomSheetDialog(context, R.style.RoundedBottomSheetDialog).apply {
            setContentView(this@AudioDeviceListView)
            setOnDismissListener {
                viewModel.closeAudioDeviceSelectionMenu()
            }

            setOnShowListener { dialog ->
                val bottomSheet = (dialog as BottomSheetDialog)
                    .findViewById<FrameLayout>(com.google.android.material.R.id.design_bottom_sheet)
                bottomSheet?.let {
                    val behavior = BottomSheetBehavior.from(it)
                    behavior.state = BottomSheetBehavior.STATE_EXPANDED
                    behavior.skipCollapsed = true
                    behavior.isDraggable = true
                    it.layoutParams.height = FrameLayout.LayoutParams.WRAP_CONTENT
                }
            }
        }

        bottomCellAdapter = BottomCellAdapter()
        bottomCellAdapter.setBottomCellItems(bottomCellItems)
        deviceTable.adapter = bottomCellAdapter
        deviceTable.layoutManager = LinearLayoutManager(context)
    }

    private val bottomCellItems: List<BottomCellItem>
        get() {
            val initialDevice = viewModel.audioStateFlow.value.device
            val bottomCellItems = mutableListOf<BottomCellItem>()

            if (!isAndroidTV(context)) {
                // Receiver (default)
                bottomCellItems.add(
                    BottomCellItem(
                        icon = ContextCompat.getDrawable(
                            context,
                            R.drawable.ic_speaker
                        ),
                        title = when (viewModel.audioStateFlow.value.isHeadphonePlugged) {
                            true -> context.getString(R.string.azure_communication_ui_calling_audio_device_drawer_headphone)
                            false -> context.getString(R.string.azure_communication_ui_calling_audio_device_drawer_android)
                        },
                        accessoryImage = ContextCompat.getDrawable(
                            context,
                            fluentUiR.drawable.ms_ic_checkmark_24_filled
                        ),
                        accessoryImageDescription = context.getString(R.string.azure_communication_ui_calling_setup_view_audio_device_selected_accessibility_label),
                        isChecked = initialDevice == AudioDeviceSelectionStatus.RECEIVER_SELECTED,
                        isOnHold = false,
                        onClickAction = {
                            viewModel.switchAudioDevice(AudioDeviceSelectionStatus.RECEIVER_REQUESTED)
                            audioDeviceDialog.dismiss()
                        }
                    )
                )
            }

            bottomCellItems.add(
                BottomCellItem(
                    icon = ContextCompat.getDrawable(
                        context,
                        R.drawable.ic_speaker
                    ),
                    title = context.getString(R.string.azure_communication_ui_calling_audio_device_drawer_speaker),
                    accessoryImage = ContextCompat.getDrawable(
                        context,
                        fluentUiR.drawable.ms_ic_checkmark_24_filled
                    ),
                    accessoryImageDescription = context.getString(R.string.azure_communication_ui_calling_setup_view_audio_device_selected_accessibility_label),
                    isChecked = initialDevice == AudioDeviceSelectionStatus.SPEAKER_SELECTED,
                    isOnHold = false,
                    onClickAction = {
                        viewModel.switchAudioDevice(AudioDeviceSelectionStatus.SPEAKER_REQUESTED)
                        audioDeviceDialog.dismiss()
                    }
                )
            )

            if (viewModel.audioStateFlow.value.bluetoothState.available) {
                // Remove the first item (Receiver)
                bottomCellItems.removeAt(0)
                bottomCellItems.add(
                    BottomCellItem(
                        icon = ContextCompat.getDrawable(
                            context,
                            R.drawable.ic_speaker_bluetooth
                        ),
                        title = viewModel.audioStateFlow.value.bluetoothState.deviceName,
                        accessoryImage = ContextCompat.getDrawable(
                            context,
                            fluentUiR.drawable.ms_ic_checkmark_24_filled
                        ),
                        accessoryImageDescription = context.getString(R.string.azure_communication_ui_calling_setup_view_audio_device_selected_accessibility_label),
                        isChecked = initialDevice == AudioDeviceSelectionStatus.BLUETOOTH_SCO_SELECTED,
                        isOnHold = false,
                        onClickAction = {
                            viewModel.switchAudioDevice(AudioDeviceSelectionStatus.BLUETOOTH_SCO_REQUESTED)
                            audioDeviceDialog.dismiss()
                        }
                    )
                )
            }

            bottomCellItems.add(
                BottomCellItem(
                    icon = ContextCompat.getDrawable(
                        context,
                        R.drawable.ic_speaker_off
                    ),
                    title = context.getString(R.string.turn_off_audio),
                    accessoryImage = ContextCompat.getDrawable(
                        context,
                        fluentUiR.drawable.ms_ic_checkmark_24_filled
                    ),
                    accessoryImageDescription = context.getString(R.string.azure_communication_ui_calling_setup_view_audio_device_selected_accessibility_label),
                    isChecked = initialDevice == AudioDeviceSelectionStatus.AUDIO_OFF_SELECTED,
                    isOnHold = false,
                    onClickAction = {
                        viewModel.switchAudioDevice(AudioDeviceSelectionStatus.AUDIO_OFF_REQUESTED)
                        audioDeviceDialog.dismiss()
                    }
                )
            )

            return bottomCellItems
        }

    private fun updateSelectedAudioDevice(audioState: AudioState) {
        if (this::bottomCellAdapter.isInitialized) {
            bottomCellAdapter.enableBottomCellItem(getDeviceTypeName(audioState))
            announceForAccessibility(
                context.getString(
                    R.string.azure_communication_ui_calling_selected_audio_device_announcement,
                    getDeviceTypeName(audioState)
                )
            )
        }
    }

    private fun getDeviceTypeName(audioState: AudioState): String {
        return when (audioState.device) {
            AudioDeviceSelectionStatus.RECEIVER_REQUESTED, AudioDeviceSelectionStatus.RECEIVER_SELECTED ->
                context.getString(R.string.azure_communication_ui_calling_audio_device_drawer_android)
            AudioDeviceSelectionStatus.SPEAKER_REQUESTED, AudioDeviceSelectionStatus.SPEAKER_SELECTED ->
                context.getString(R.string.azure_communication_ui_calling_audio_device_drawer_speaker)
            AudioDeviceSelectionStatus.AUDIO_OFF_REQUESTED, AudioDeviceSelectionStatus.AUDIO_OFF_SELECTED ->
                context.getString(R.string.turn_off_audio)
            AudioDeviceSelectionStatus.BLUETOOTH_SCO_SELECTED, AudioDeviceSelectionStatus.BLUETOOTH_SCO_REQUESTED ->
                audioState.bluetoothState.deviceName
        }
    }

    private fun updateNoiseSuppressionState(audioState: AudioState) {
        noiseSuppressionSwitch.isChecked = audioState.noiseSuppression == NoiseSuppressionStatus.ON
    }
}
