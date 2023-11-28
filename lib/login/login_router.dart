import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:Bubble/login/page/new_register_page.dart';
import 'package:Bubble/login/page/bind_phone_page.dart';
import 'package:Bubble/login/page/login_page.dart';
import 'package:Bubble/login/page/only_sms_page.dart';
import 'package:Bubble/login/page/register_page.dart';
import 'package:Bubble/login/page/sms_login_page.dart';

import '../routers/i_router.dart';
import 'entity/wx_info_entity.dart';


class LoginRouter implements IRouterProvider{

  // static String loginPage = '/login';
  static String loginPage = '/newlogin';
  static String registerPage = '/login/register';
  static String smsLoginPage = '/login/smsLogin';
  static String onlySmsPage = '/login/onlySmsLogin';
  static String bindPhonePage = "/login/BindPhonePage";
  static String resetPasswordPage = '/login/resetPassword';
  static String updatePasswordPage = '/login/updatePassword';
  
  @override
  void initRouter(FluroRouter router) {
    // router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const LoginPage()));
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const NewRegisterPage()));
    router.define(registerPage, handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
    router.define(smsLoginPage, handler: Handler(handlerFunc: (_, __) => const SMSLoginPage()));
    router.define(onlySmsPage, handler: Handler(handlerFunc: (_, __) => const OnlySmsPage()));
    router.define(bindPhonePage, handler: Handler(handlerFunc: (context, params) {
      WxInfoDataData entity = WxInfoDataData();
      if(context!=null){
        entity = ModalRoute.of(context)?.settings.arguments as WxInfoDataData;
      }
      return  BindPhonePage(entity);
    }));
    // router.define(resetPasswordPage, handler: Handler(handlerFunc: (_, __) => const ResetPasswordPage()));
    // router.define(updatePasswordPage, handler: Handler(handlerFunc: (_, __) => const UpdatePasswordPage()));
  }
  
}
