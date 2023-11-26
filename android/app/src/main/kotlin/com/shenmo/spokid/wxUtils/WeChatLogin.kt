package com.shenmo.spokid.wxUtils

import android.widget.Toast
import com.shenmo.spokid.SpokidApp
import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelmsg.SendAuth
import com.tencent.mm.opensdk.openapi.IWXAPI

class WeChatLogin {
    companion object {


        fun login(
            wechatInfo: WechatInfoBean?=null,
            api: IWXAPI?,

        ) {

            api?.apply {
                if (!isWXAppInstalled){
                    Toast.makeText(SpokidApp.spokidApplication,"未安装微信",Toast.LENGTH_SHORT).show()
                }else{
                    val req = SendAuth.Req()
                    //应用授权作用域，如获取用户个人信息则填写 snsapi_userinfo
//            req.scope = "snsapi_userinfo"
//            req.state = "wx_login" //非必须
                    req.scope = wechatInfo?.scope?:"snsapi_userinfo"
                    req.state = wechatInfo?.state?:"wx_login"
                    api.sendReq(req)
                }
            }


        }

        /**
         * 处理微信登录结果
         */
        fun executeLoginResp(baseResp: SendAuth.Resp,sWeChatLoginResultListener: WeChatLoginResultListener) {

            when (baseResp.errCode) {
                BaseResp.ErrCode.ERR_OK -> {
                    sWeChatLoginResultListener.onSuccess(
                        baseResp.code
                    )
                }
                BaseResp.ErrCode.ERR_USER_CANCEL -> sWeChatLoginResultListener.onCancel()
                else -> sWeChatLoginResultListener.onError(baseResp.errStr)
            }

        }
    }


}