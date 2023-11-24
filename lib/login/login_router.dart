import 'package:fluro/fluro.dart';
import 'package:spokid/login/page/bind_phone_page.dart';
import 'package:spokid/login/page/login_page.dart';
import 'package:spokid/login/page/register_page.dart';
import 'package:spokid/login/page/sms_login_page.dart';

import '../routers/i_router.dart';


class LoginRouter implements IRouterProvider{

  static String loginPage = '/login';
  static String registerPage = '/login/register';
  static String smsLoginPage = '/login/smsLogin';
  static String bindPhonePage = "/login/BindPhonePage";
  static String resetPasswordPage = '/login/resetPassword';
  static String updatePasswordPage = '/login/updatePassword';
  
  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage, handler: Handler(handlerFunc: (_, __) => const LoginPage()));
    router.define(registerPage, handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
    router.define(smsLoginPage, handler: Handler(handlerFunc: (_, __) => const SMSLoginPage()));
    router.define(bindPhonePage, handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
        final String wechatCode = params['wechatCode']?.first ?? '';
      return  BindPhonePage(wechatCode);
    }));
    // router.define(resetPasswordPage, handler: Handler(handlerFunc: (_, __) => const ResetPasswordPage()));
    // router.define(updatePasswordPage, handler: Handler(handlerFunc: (_, __) => const UpdatePasswordPage()));
  }
  
}
