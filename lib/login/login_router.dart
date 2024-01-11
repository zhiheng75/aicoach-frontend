// ignore_for_file: unnecessary_cast

import 'dart:ffi';

import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:Bubble/login/page/change_bind_phone_page.dart';
import 'package:Bubble/login/page/check_code_page.dart';
import 'package:Bubble/login/page/new_bind_phone_page.dart';
import 'package:Bubble/login/page/new_one_key_phone_page.dart';
import 'package:Bubble/login/page/one_key_login_page.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:Bubble/login/page/new_register_page.dart';
import 'package:Bubble/login/page/bind_phone_page.dart';
import 'package:Bubble/login/page/login_page.dart';
import 'package:Bubble/login/page/only_sms_page.dart';
import 'package:Bubble/login/page/register_page.dart';
import 'package:Bubble/login/page/sms_login_page.dart';

import '../routers/i_router.dart';
import 'entity/login_info_entity.dart';
import 'entity/wx_info_entity.dart';
import 'page/phone_login_page.dart';

class LoginRouter implements IRouterProvider {
  // static String loginPage = '/login';
  static String loginPage = '/newlogin';
  static String registerPage = '/login/register';
  static String smsLoginPage = '/login/smsLogin';
  static String onlySmsPage = '/login/onlySmsLogin';
  // static String bindPhonePage = "/login/BindPhonePage";
  static String changeBindPhonePage = "/login/ChangeBindPhonePage";
  static String resetPasswordPage = '/login/resetPassword';
  static String updatePasswordPage = '/login/updatePassword';
  static String keyLoginPage = "/login/keyLogin";
  static String keyCheckCodePage = "/login/CheckCodePage";
  static String keyCheckTwoCodePage = "/login/CheckTwoCodePage";

  static String phoneLoginPage = "/login/PhoneLoginPage";
  static String newOneKeyPhonePage = "/login/NewOneKeyPhonePage";

  static String newBindPhonePage = "/login/NewBindPhonePage";

  @override
  void initRouter(FluroRouter router) {
    // router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const LoginPage()));
    router.define(loginPage, handler: Handler(handlerFunc: (_, params) {
      //0 一键登录  1 其他登录
      bool keyLogin = false;
      final int index = int.parse(params['needKeyLogin']?.first ?? '1');

      keyLogin = index == 0;

      return NewRegisterPage(isKeyLogin: keyLogin);
    }));
    router.define(registerPage,
        handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
    router.define(smsLoginPage,
        handler: Handler(handlerFunc: (_, __) => const SMSLoginPage()));
    router.define(keyLoginPage,
        handler: Handler(handlerFunc: (_, __) => const KeyLoginPage()));
    router.define(onlySmsPage,
        handler: Handler(handlerFunc: (_, __) => const OnlySmsPage()));

    router.define(keyCheckCodePage, handler: Handler(handlerFunc: (_, params) {
      String phoneNumberStr = params['PhoneNumber']!.first;
      String typeLogin = params['typeLogin']!.first;

      return CheckCodePage(
        phoneNumber: phoneNumberStr,
        typeLogin: typeLogin,
      );
    }));

    router.define(keyCheckTwoCodePage,
        handler: Handler(handlerFunc: (context, params) {
      String phoneNumberStr = params['PhoneNumber']!.first;
      NewWxInfoBeanData entity =
          ModalRoute.of(context!)?.settings.arguments as NewWxInfoBeanData;

      return CheckTwoCodePage(
        phoneNumber: phoneNumberStr,
        wechatData: entity,
      );
    }));

    router.define(phoneLoginPage,
        handler: Handler(handlerFunc: (_, __) => const PhoneLoginPage()));

    router.define(newOneKeyPhonePage,
        handler: Handler(handlerFunc: (_, params) {
      //0 一键登录  1 其他登录
      String keyLogin = params['typeLogin']!.first;

      return NewOneKeyPhonePage(typeLogin: keyLogin);
    }));

    // router.define(bindPhonePage, handler: Handler(handlerFunc: (context, params) {
    // LoginInfoDataData entity = LoginInfoDataData();
    // if(context!=null){
    //   entity = ModalRoute.of(context)?.settings.arguments as LoginInfoDataData;
    // }
    //   return  BindPhonePage(entity);
    // }));
    router.define(changeBindPhonePage,
        handler: Handler(handlerFunc: (context, params) {
      LoginInfoDataData entity = LoginInfoDataData();
      if (context != null) {
        entity =
            ModalRoute.of(context)?.settings.arguments as LoginInfoDataData;
      }
      return ChangeBindPhonePage(entity);
    }));

    router.define(newBindPhonePage,
        handler: Handler(handlerFunc: (context, params) {
      NewWxInfoBeanData entity =
          ModalRoute.of(context!)?.settings.arguments as NewWxInfoBeanData;
      Log.e("===============");

      Log.e(entity.toString());
      Log.e(entity.openid);

      Log.e("===============");

      return NewBindPhonePage(wechatData: entity);
    }));

    // router.define(resetPasswordPage, handler: Handler(handlerFunc: (_, __) => const ResetPasswordPage()));
    // router.define(updatePasswordPage, handler: Handler(handlerFunc: (_, __) => const UpdatePasswordPage()));
  }
}
