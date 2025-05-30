package com.acs_plugin.calling.presentation.fragment.calling.moreactions

import android.content.Context
import android.util.AttributeSet
import android.view.Gravity
import android.widget.LinearLayout
import androidx.appcompat.widget.AppCompatImageView
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.MoreActionItem
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.MoreActionType
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView

class MoreActionItemView @JvmOverloads constructor(
    context: Context, attrs: AttributeSet? = null
) : LinearLayout(context, attrs) {

    private val iconView: AppCompatImageView
    private val labelView: MaterialTextView

    init {
        orientation = VERTICAL
        gravity = Gravity.CENTER
        inflate(context, R.layout.item_action_more, this)
        iconView = findViewById(R.id.action_icon)
        labelView = findViewById(R.id.action_label)
    }

    fun setAction(
        item: MoreActionItem,
        onClick: (MoreActionType) -> Unit = {}
    ) {
        iconView.setImageResource(item.iconResId)
        iconView.isEnabled = item.isEnabled
        labelView.setText(item.titleResId)
        labelView.isEnabled = item.isEnabled

        if (item.isEnabled) onSingleClickListener { onClick(item.type) }
    }
}