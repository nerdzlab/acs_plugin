package com.acs_plugin.extension

fun Boolean?.falseIfNull(): Boolean {
    return this == true
}