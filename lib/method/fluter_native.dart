
import 'dart:convert';

import 'package:flutter/services.dart';

import '../person/entity/wx_pay_entity.dart';

///和原生通讯
 class FlutterToNative{

  //平台通道––––跳转到Android页面
  static const methodChannelPlatform = MethodChannel('flutter.jumpto.android');

  //跳转到Android页面
  static Future<void> jumpToAndroidMethod() async {
    final String result = await methodChannelPlatform.invokeMethod('jumpToAndroidPage');

  }

  //微信登录
  static Future<String> jumpToWechatLogin() async {
    final String result = await methodChannelPlatform.invokeMethod("jumpToWechatLogin");
    return result;
  }

  //微信支付
  static Future<int> jumpToWechatPay(String bean) async{
    // final String result = await methodChannelPlatform.invokeMethod("jumpToWechatPay",{"key":"value","key1":"value1"});
    final int result = await methodChannelPlatform.invokeMethod("jumpToWechatPay",bean);
    return result;
  }

  //支付宝支付
  static Future<int> jumpToALiPay(String bean) async{
    final int result = await methodChannelPlatform.invokeMethod("jumpToALiPay",bean);
    return result;
  }

  //一键登录
  static Future<String> jumpToKeyLogin() async {
    final String result = await methodChannelPlatform.invokeMethod("keyLogin");
    return result;

  }
}