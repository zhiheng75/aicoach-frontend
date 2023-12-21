import 'package:Bubble/constant/constant.dart';
import 'package:Bubble/home/home.dart';
import 'package:Bubble/login/login_router.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';
import 'package:jverify/jverify.dart';
import '../util/other_utils.dart';
import '../widgets/load.dart';

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
      //跳转登录()
      LoadingDialog.show(context);
      int type = 1;//0 一键登录  1 其他登录
      isInitSuccess().then((value) => {
            if (value)
              {
                checkVerifyEnable().then((value) => {
                      if (value)
                        {
                          getToken().then((value) => {
                                if (value)
                                  {
                                    type = 0,
                                  }
                                else
                                  {
                                    type = 1,
                                  },
                                LoadingDialog.hidden(),
                                NavigatorUtils.push(context,
                                    "${LoginRouter.loginPage}?needKeyLogin=$type"),
                              })
                        }
                      else
                        {
                          LoadingDialog.hidden(),
                          NavigatorUtils.push(context, LoginRouter.loginPage),
                        }
                    })
              }
            else
              {
                LoadingDialog.hidden(),
                NavigatorUtils.push(context, LoginRouter.loginPage),
              }
          });
    }
  }


  /// sdk 初始化是否完成
   static Future<bool> isInitSuccess()  async{


   return Constant.jverify.isInitSuccess().then((map) {

      bool result = map[Constant.jgResultKey];

      if (result) {
        // "sdk 初始换成功";
        return true;
      } else {
        // "sdk 初始换失败";
        return false;
      }

    });

  }

  /// 判断当前网络环境是否可以发起认证
  static Future<bool> checkVerifyEnable() async{
    return  Constant.jverify.checkVerifyEnable().then((map) {
      bool result = map[Constant.jgResultKey];

        if (result) {
          //"当前网络环境【支持认证】！";
          return true;
        } else {
          //"当前网络环境【不支持认证】！";
          return false;
        }

    });
  }

  /// 获取号码认证token
  static Future<bool> getToken() async{

    return Constant.jverify.getToken().then((map) {
      int code = map[Constant.jgCodeKey];///6000
      String token = map[Constant.jgMsgKey];///

      if(code==2000&&token!=null&&token.isNotEmpty){
        return true;
      }else{
        Toast.show(token);
        return false;
      }
    });
  }

  static clearToken(){
    SpUtil.remove(Constant.accessToken);
  }

  static toLoginOut(){
    SpUtil.remove(Constant.accessToken);
    SpUtil.remove(Constant.userInfoKey);
  }

  static int getUserId() {
    if (!isLogin()) {
      return 0;
    }
    Map<dynamic, dynamic>? userInfo = SpUtil.getObject(Constant.userInfoKey);
    if (userInfo == null) {
      return 0;
    }
    return userInfo['id'] as int;
  }
}