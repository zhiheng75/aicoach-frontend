
import 'package:flutter/services.dart';

 class FlutterToNative{

  //平台通道––––跳转到Android页面
  static const platform = MethodChannel('flutter.jumpto.android');

  //跳转到Android页面
  static Future<void> jumpToAndroidMethod() async {
    final String result = await platform.invokeMethod('jumpToAndroidPage');
    print('result===$result');
  }

  static Future<String> jumpToWechatLogin() async {
    final String result = await platform.invokeMethod("jumpToWechatLogin");
    return result;
  }

  static Future<String> jumpToKeyLogin() async {
    final String result = await platform.invokeMethod("keyLogin");
    return result;

  }
}