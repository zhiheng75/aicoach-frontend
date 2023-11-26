package com.shenmo.spokid.wxUtils

interface WeChatPayResultListener {

    fun onSuccess()

    fun onCancel()

    fun onError(error: String?)
}