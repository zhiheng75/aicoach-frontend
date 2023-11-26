package com.shenmo.spokid.wxUtils

interface WeChatShareResultListener {

    fun onSuccess()

    fun onCancel()

    fun onError(error: String?)
}