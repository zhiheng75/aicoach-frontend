import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import '../util/other_utils.dart';

class LoginManager{

  static bool isLogin()  {
    final String token = SpUtil.getString(Constant.accessToken).nullSafe;
     return token.isNotEmpty;
  }

  static void checkLogin(BuildContext context, Function toNext)  {
    final String accessToken = SpUtil.getString(Constant.accessToken).nullSafe;
    if (accessToken.isNotEmpty) {
      toNext();
    }else{
      NavigatorUtils.push(context, LoginRouter.loginPage);
    }
  }

  static clearToken(){
    SpUtil.remove(Constant.accessToken);
  }

  static toLoginOut(){
    SpUtil.remove(Constant.accessToken);
    SpUtil.remove(Constant.userInfoKey);
  }
}