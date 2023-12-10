package com.shenmo.spokid.entity

data class ALiPayResult(
    val alipay_trade_app_pay_response: AlipayTradeAppPayResponse,
    val sign: String,
    val sign_type: String
)