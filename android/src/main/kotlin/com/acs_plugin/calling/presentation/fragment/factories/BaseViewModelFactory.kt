package com.acs_plugin.calling.presentation.fragment.factories

import com.acs_plugin.calling.presentation.fragment.setup.components.ErrorInfoViewModel
import com.acs_plugin.calling.presentation.fragment.setup.components.PermissionWarningViewModel
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.state.ReduxState

internal open class BaseViewModelFactory constructor(
    private val store: Store<ReduxState>,
) {
    val warningsViewModel by lazy {
        PermissionWarningViewModel(store::dispatch)
    }

    val errorInfoViewModel by lazy {
        ErrorInfoViewModel()
    }
}
