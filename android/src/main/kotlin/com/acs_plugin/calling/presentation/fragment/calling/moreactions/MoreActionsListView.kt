package com.acs_plugin.calling.presentation.fragment.calling.moreactions

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.LinearLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import com.acs_plugin.calling.utilities.implementation.CompositeDrawerDialog
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.flexbox.FlexboxLayout
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.drawer.DrawerDialog
import kotlinx.coroutines.launch

internal class MoreActionsListView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null
) : LinearLayout(context, attrs) {

    private lateinit var viewModel: MoreActionsListViewModel

    private var emojiLike: MaterialTextView
    private var emojiHeart: MaterialTextView
    private var emojiApplause: MaterialTextView
    private var emojiLaugh: MaterialTextView
    private var emojiSurprised: MaterialTextView
    private var actionsFlexboxLayer: FlexboxLayout

    private lateinit var menuDrawer: DrawerDialog

    init {
        orientation = VERTICAL
        LayoutInflater.from(context).inflate(R.layout.more_actions_list_view, this, true)

        emojiLike = findViewById<MaterialTextView>(R.id.emoji_like)
        emojiLike.onSingleClickListener { sendReaction(ReactionType.LIKE) }

        emojiHeart = findViewById<MaterialTextView>(R.id.emoji_heart)
        emojiHeart.onSingleClickListener { sendReaction(ReactionType.HEART) }

        emojiApplause = findViewById<MaterialTextView>(R.id.emoji_applause)
        emojiApplause.onSingleClickListener { sendReaction(ReactionType.APPLAUSE) }

        emojiLaugh = findViewById<MaterialTextView>(R.id.emoji_laugh)
        emojiLaugh.onSingleClickListener { sendReaction(ReactionType.LAUGH) }

        emojiSurprised = findViewById<MaterialTextView>(R.id.emoji_surprised)
        emojiSurprised.onSingleClickListener { sendReaction(ReactionType.SURPRISED) }

        actionsFlexboxLayer = findViewById<FlexboxLayout>(R.id.action_flexbox_layout)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        viewModel: MoreActionsListViewModel
    ) {
        this.viewModel = viewModel

        initializeDrawer()

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.displayStateFlow.collect {
                if (it) {
                    menuDrawer.show()
                }
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.actionItemsFlow.collect {
                actionsFlexboxLayer.removeAllViews()

                val lp = FlexboxLayout.LayoutParams(0, WRAP_CONTENT).apply {
                    flexGrow = 1f
                    flexBasisPercent = 0.3f // 3 per row
                }

                it.forEach { item ->
                    val actionView = MoreActionItemView(context)
                    actionView.setAction(item) {
                        menuDrawer.dismissDialog()
                        viewModel.onActionClicked(it)
                    }
                    actionsFlexboxLayer.addView(actionView, lp)
                }
            }
        }

    }

    fun stop() {
        menuDrawer.dismiss()
        this.removeAllViews()
    }

    private fun initializeDrawer() {
        menuDrawer = CompositeDrawerDialog(
            context,
            DrawerDialog.BehaviorType.BOTTOM,
            R.string.azure_communication_ui_calling_view_more_menu_list_accessibility_label,
        )
        menuDrawer.setContentView(this)
        menuDrawer.setOnDismissListener {
            viewModel.close()
        }
    }

    private fun sendReaction(reactionType: ReactionType) {
        menuDrawer.dismissDialog()
        viewModel.onSendReaction(reactionType)
    }

}
