
import 'package:flutter/services.dart';

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
  static Future<void> jumpToWechatPay() async{
    final String result = await methodChannelPlatform.invokeMethod("jumpToWechatPay",{"key":"value","key1":"value1"});
  }

  //一键登录
  static Future<String> jumpToKeyLogin() async {
    final String result = await methodChannelPlatform.invokeMethod("keyLogin");
    return result;

  }
}