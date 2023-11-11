import 'package:fluro/fluro.dart';
import 'package:spokid/home/home.dart';

import '../routers/i_router.dart';

class HomeRouter implements IRouterProvider{

  static String homePage = '/home';

  @override
  void initRouter(FluroRouter router) {
    router.define(homePage, handler: Handler(handlerFunc: (_, __) => const HomePage()));
  }

}