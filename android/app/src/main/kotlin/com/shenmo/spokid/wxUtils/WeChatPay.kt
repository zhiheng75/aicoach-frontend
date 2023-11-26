package com.shenmo.spokid.wxUtils

import com.tencent.mm.opensdk.modelbase.BaseResp
import com.tencent.mm.opensdk.modelpay.PayReq
import com.tencent.mm.opensdk.openapi.IWXAPI

class WeChatPay {
    companion object{

        var sWeChatPayResultListener: WeChatPayResultListener? = null

        /**
         * @param partnerId 商户号
         * @param prepayId  预支付交易会话ID
         * @param nonceStr  随机字符串
         * @param timeStamp 时间戳
         * @param sign      签名
         */
        fun pay(
            api: IWXAPI,
            partnerId: String?,
            prepayId: String?,
            nonceStr: String?,
            timeStamp: String?,
            sign: String?,
            weChatPayResultListener: WeChatPayResultListener?
        ) {
            sWeChatPayResultListener = weChatPayResultListener
            val request = PayReq()
            request.appId = WeChatSdk.sAppId
            request.partnerId = partnerId
            request.prepayId = prepayId
            request.packageValue = "Sign=WXPay"
            request.nonceStr = nonceStr
            request.sign = sign
            request.timeStamp = timeStamp
            api.sendReq(request)
        }

        /**
         * 处理微信支付结果
         */
        fun executePayResp(baseResp: BaseResp) {
            if (sWeChatPayResultListener == null) return
            when (baseResp.errCode) {
                BaseResp.ErrCode.ERR_OK -> sWeChatPayResultListener!!.onSuccess()
                BaseResp.ErrCode.ERR_USER_CANCEL -> sWeChatPayResultListener!!.onCancel()
                else -> sWeChatPayResultListener!!.onError(baseResp.errStr)
            }
            sWeChatPayResultListener = null
        }
    }
}