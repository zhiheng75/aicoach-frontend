package com.shenmo.spokid

import android.app.Application
import android.content.Context
//import cn.jiguang.verifysdk.api.JVerificationInterface
import com.shenmo.spokid.wxUtils.WeChatSdk.Companion.init
import kotlin.properties.Delegates

class SpokidApp : Application() {

    override fun onCreate() {
        super.onCreate()
        spokidApplication = applicationContext
//        init(this,BuildConfig.WXID)
//        JVerificationInterface.init(this)
//        JVerificationInterface.setDebugMode(true)
    }


    companion object {
        var spokidApplication: Context by Delegates.notNull()

    }
}