import 'package:fluro/fluro.dart';
import 'package:Bubble/home/home.dart';

import '../test/TestPage.dart';
import '../routers/i_router.dart';

class HomeRouter implements IRouterProvider{

  static String homePage = '/home';
  static String demoTest = "/TestPage";

  @override
  void initRouter(FluroRouter router) {
    router.define(homePage, handler: Handler(handlerFunc: (_, __) => const HomePage()));

    router.define(demoTest, handler:  Handler(handlerFunc: (_, __) => const Testpage()));
  }

}