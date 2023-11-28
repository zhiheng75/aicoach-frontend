import 'package:fluro/fluro.dart';
import 'package:Bubble/setting/setting_page.dart';
import 'package:Bubble/setting/theme_page.dart';

import '../routers/i_router.dart';

class SettingRouter implements IRouterProvider{

  static String settingPage = '/setting';
  static String themePage = '/setting/theme';

  
  @override
  void initRouter(FluroRouter router) {
    router.define(settingPage, handler: Handler(handlerFunc: (_, __) => const SettingPage()));

    router.define(themePage, handler: Handler(handlerFunc: (_, __) => const ThemePage()));

  }
  
}
