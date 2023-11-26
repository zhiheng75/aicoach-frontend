package com.shenmo.spokid.wxUtils

import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import com.shenmo.spokid.BuildConfig
import com.tencent.mm.opensdk.constants.Build
import com.tencent.mm.opensdk.openapi.WXAPIFactory

class WeChatSdk {
    companion object {

        val wechatSdk: WeChatSdkImpl = WeChatSdkImpl()

        var sAppId = ""

        @SuppressLint("StaticFieldLeak")
        var sContext: Context? = null

        /**
         * 初始化微信sdk
         *
         * @param application application
         * @param appId       微信appId
         */
        fun init(application: Application?, appId: String) {
            sAppId = appId
            sContext = application
            wechatSdk.init(application, appId)
        }

        /**
         * 微信登陆
         *
         * @param weChatLoginResultListener 登陆结果回调
         */
        fun login(context: Context,wechatInfo: WechatInfoBean?=null) {
            val sWxApi = WXAPIFactory.createWXAPI(context, BuildConfig.WXID, false)
            sWxApi.registerApp(BuildConfig.WXID)
            WeChatLogin.login(wechatInfo,sWxApi)
        }



        /**
         * 微信支付
         *
         * @param partnerId               商户号
         * @param prepayId                预支付交易会话ID
         * @param nonceStr                随机字符串
         * @param timeStamp               时间戳
         * @param sign                    签名
         * @param weChatPayResultListener 支付结果
         */
        fun pay(
            partnerId: String?,
            prepayId: String?,
            nonceStr: String?,
            timeStamp: String?,
            sign: String?,
            weChatPayResultListener: WeChatPayResultListener?
        ) {
            WeChatPay.pay(
                wechatSdk.getWxApi()!!,
                partnerId,
                prepayId,
                nonceStr,
                timeStamp,
                sign,
                weChatPayResultListener
            )
        }

        /**
         * 分享到微信
         *
         * @param title                     标题
         * @param description               描述
         * @param contentUrl                内容链接
         * @param imageUrl                  图片路径，可以是文件路径或者网络图片 url
         * @param weChatShareResultListener 分享结果回调
         */
        fun shareToWechat(
            title: String?,
            description: String?,
            contentUrl: String?,
            imageUrl: String?,
            weChatShareResultListener: WeChatShareResultListener?
        ) {
            WeChatShare.shareToWechat(
                wechatSdk.getWxApi()!!,
                title!!, description!!, contentUrl!!,
                imageUrl!!, weChatShareResultListener
            )
        }

        /**
         * 分享到微信朋友圈
         *
         * @param title                     标题
         * @param description               描述
         * @param contentUrl                内容链接
         * @param imageUrl                  图片路径，可以是文件路径或者网络图片 url
         * @param weChatShareResultListener 分享结果回调
         */
        fun shareToMoment(
            title: String?,
            description: String?,
            contentUrl: String?,
            imageUrl: String?,
            weChatShareResultListener: WeChatShareResultListener?
        ) {
            WeChatShare.shareToMoment(
                wechatSdk.getWxApi()!!,
                title!!, description!!, contentUrl!!,
                imageUrl!!, weChatShareResultListener
            )
        }


        /**
         * 分享到微信小程序
         *
         * @param title                     标题
         * @param description               描述
         * @param path                      小程序 页面 路径
         * @param username                  小程序 username
         * @param contentUrl                内容链接
         * @param imageUrl                  图片路径，可以是文件路径或者网络图片 url
         * @param weChatShareResultListener 分享结果回调
         */
        fun shareToMiniProgram(
            title: String?,
            description: String?,
            path: String?,
            username: String?,
            contentUrl: String?,
            imageUrl: String?,
            weChatShareResultListener: WeChatShareResultListener?
        ) {
            WeChatShare.shareToMiniProgram(
                wechatSdk.getWxApi()!!,
                title, description,
                path, username, contentUrl,
                imageUrl!!, weChatShareResultListener
            )
        }


        /**
         * 是否安装有微信
         */
        fun isInstallWechat(): Boolean {
            return wechatSdk.getWxApi()!!.isWXAppInstalled
        }

        /**
         * 是否支持朋友圈
         */
        fun isSupportMoment(): Boolean {
            return wechatSdk.getWxApi()!!.wxAppSupportAPI >= Build.TIMELINE_SUPPORTED_SDK_INT
        }
    }
}