import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../changeRole/change_role_router.dart';
import '../common/webview_page.dart';
import '../conversation/conversation_router.dart';
import '../home/home_router.dart';
import '../login/login_router.dart';
import '../order/order_router.dart';
import '../person/person_router.dart';
import '../report/report_router.dart';
import 'i_router.dart';
import 'not_found_page.dart';

class Routes {
  static String home = '/home';
  static String webViewPage = '/webView';

  static final List<IRouterProvider> _listRouter = [];

  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        debugPrint('未找到目标页');
        return const NotFoundPage();
      },
    );

    router.define(webViewPage, handler: Handler(handlerFunc: (_, params) {
      Log.e(params.toString());
      final String title = params['title']?.first ?? '';
      final String url = params['url']?.first ?? '';
      return WebViewPage(title: title, url: url);
    }));

    _listRouter.clear();

    /// 各自路由由各自模块管理，统一在此添加初始化

    _listRouter.add(LoginRouter());
    _listRouter.add(HomeRouter());
    _listRouter.add(ReportRouter());
    _listRouter.add(ChangeRoleRouter());
    _listRouter.add(PersonalRouter());
    _listRouter.add(ConversationRouter());
    _listRouter.add(MyOrderRouter());
    _listRouter.add(ExamRouter());

    /// 初始化路由
    void initRouter(IRouterProvider routerProvider) {
      routerProvider.initRouter(router);
    }

    _listRouter.forEach(initRouter);
  }
}
