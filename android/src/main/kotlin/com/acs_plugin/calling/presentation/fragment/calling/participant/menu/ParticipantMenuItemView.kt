package com.acs_plugin.calling.presentation.fragment.calling.participant.menu

import android.content.Context
import android.util.AttributeSet
import android.widget.LinearLayout
import androidx.appcompat.widget.AppCompatImageView
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data.ParticipantMenuItem
import com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data.ParticipantMenuType
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView

class ParticipantMenuItemView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : LinearLayout(context, attrs) {

    private val iconView: AppCompatImageView
    private val labelView: MaterialTextView

    init {
        inflate(context, R.layout.item_participant_menu, this)
        iconView = findViewById(R.id.menu_icon)
        labelView = findViewById(R.id.menu_label)
    }

    fun setAction(
        item: ParticipantMenuItem,
        onClick: (ParticipantMenuType) -> Unit = {}
    ) {
        iconView.setImageResource(item.iconResId)
        iconView.isEnabled = item.isEnabled
        labelView.setText(item.titleResId)
        labelView.isEnabled = item.isEnabled

        if (item.isEnabled) onSingleClickListener { onClick(item.type) }
    }
}