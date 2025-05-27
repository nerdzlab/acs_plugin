package com.acs_plugin.calling.presentation.fragment.calling.reactionoverlay

import android.content.Context
import android.util.AttributeSet
import android.view.Gravity
import android.widget.FrameLayout
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import com.acs_plugin.extension.setTextColorResource
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class ReactionOverlayView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null,
    defStyleAttr: Int = 0
) : FrameLayout(context, attrs, defStyleAttr) {

    private val emojiTextView = MaterialTextView(context).apply {
        textSize = 40f
        setTextColorResource(R.color.text_primary)
        gravity = Gravity.CENTER
    }

    private var hideJob: Job? = null

    init {
        layoutParams = LayoutParams(
            LayoutParams.MATCH_PARENT,
            LayoutParams.MATCH_PARENT
        )

        setBackgroundResource(R.drawable.bg_white_op_40_rounded_r12)
        isClickable = false
        isFocusable = false

        addView(
            emojiTextView,
            LayoutParams(
                LayoutParams.WRAP_CONTENT,
                LayoutParams.WRAP_CONTENT,
                Gravity.CENTER
            )
        )

        visibility = GONE
    }

    fun show(reaction: ReactionType?) {
        if (reaction != null) {
            emojiTextView.setText(reaction.titleResId)
            visibility = VISIBLE

            hideJob?.cancel()
            hideJob = CoroutineScope(Dispatchers.Main).launch {
                delay(3000L)
                visibility = GONE
            }
        }
    }
}