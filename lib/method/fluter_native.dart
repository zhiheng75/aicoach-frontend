
import 'package:flutter/services.dart';

class FlutterToNative{

  //平台通道––––跳转到Android页面
  static const platform = MethodChannel('flutter.jumpto.android');

  //跳转到Android页面
  Future<Null> _jumpToAndroidMethod() async {
    final String result = await platform.invokeMethod('jumpToAndroidPage');
    print('result===$result');

  }
}