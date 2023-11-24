package com.shenmo.spokid.channal

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

 class JumpChannel(flutterEngine: BinaryMessenger, activity: FlutterActivity): MethodChannel.MethodCallHandler {
    private val batteryChannelName = "flutter.jumpto.android"
    private var channel: MethodChannel
    private var mActivity: FlutterActivity
    private lateinit var mResult: MethodChannel.Result

    init {
        channel = MethodChannel(flutterEngine, batteryChannelName)
        channel.setMethodCallHandler(this)
        mActivity = activity
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        this.mResult = result
        if (call.method == "jumpToAndroidPage") {

//            var  intent = Intent(mActivity,SecondActivity::class.java)
//            mActivity.startActivity(intent)

            result.success("跳转");
        }else if(call.method == "别的method"){
            //处理samples.flutter.jumpto.android下别的method方法
        } else if (call.method == "jumpToWechatLogin") {
//            result.success()
//            result.error()
//            WeChatSdk.login(mActivity)
//            val  intent = Intent(mActivity, SecondActivity::class.java)
//            mActivity.startActivity(intent)
        }
        else {
            result.notImplemented()
        }
    }

}