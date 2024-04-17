import 'package:Bubble/TabMain/main_tabber.dart';
import 'package:Bubble/scene/scene.dart';
import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import '../test/TestPage.dart';
import 'home.dart';
import 'home_new.dart';

class HomeRouter implements IRouterProvider {
  static String homePage = '/home';
  static String tabberPage = '/tabber';
  static String scenePage = '/scenePage';

  @override
  void initRouter(FluroRouter router) {
    // router.define(homePage, handler: Handler(handlerFunc: (_, __) => const HomePage()));

    router.define(homePage, handler: Handler(handlerFunc: (_, params) {
      //人物
      String index = params['index']!.first;
      int idx = int.parse(index);
      return HomeNewPage(index: idx);
    }));

    router.define(tabberPage,
        handler: Handler(handlerFunc: (_, __) => const MainTabber()));

    router.define(scenePage,
        handler: Handler(
            handlerFunc: (_, __) => ScenePage(
                  onEnd: () {},
                )));
  }
}
