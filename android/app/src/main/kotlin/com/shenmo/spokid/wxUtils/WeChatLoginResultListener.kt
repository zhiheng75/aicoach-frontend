package com.shenmo.spokid.wxUtils

interface WeChatLoginResultListener {

    /**
     * @param code 用户身份标识
     */
    fun onSuccess(code: String?)

    fun onCancel()

    fun onError(error: String?)
}