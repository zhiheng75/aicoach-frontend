package com.shenmo.spokid.entity

data class WxPayBean(
    val appid: String,
    val noncestr: String,
    val `package`: String,
    val partnerid: String,
    val prepay_id: String,
    val sign: String,
    val timestamp: String
)