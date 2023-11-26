package com.shenmo.spokid.wxUtils

import android.app.Application
import com.tencent.mm.opensdk.openapi.IWXAPI
import com.tencent.mm.opensdk.openapi.WXAPIFactory

class WeChatSdkImpl {
    private var sWxApi: IWXAPI? = null

    /**
     * 初始化sdk
     */
    fun init(application: Application?, appId: String?) {
        sWxApi = WXAPIFactory.createWXAPI(application, appId, true)
        sWxApi!!.registerApp(appId)
    }

    fun getWxApi(): IWXAPI? {
        if (sWxApi == null) {
            throw NullPointerException("微信sdk尚未初始化")
        }
        return sWxApi
    }

}