package com.shenmo.spokid.wxUtils

import java.io.Serializable


class WechatInfoBean(
    val appid: String,
    val scope: String,
    val state: String,
) :Serializable