import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'home_new.dart';

class HomeRouter implements IRouterProvider{

  static String homePage = '/home';

  @override
  void initRouter(FluroRouter router) {
    // router.define(homePage, handler: Handler(handlerFunc: (_, __) => const HomePage()));
    router.define(homePage, handler: Handler(handlerFunc: (_, __) => const HomeNewPage()));
  }

}