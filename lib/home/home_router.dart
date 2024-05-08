import 'package:Bubble/home/page/course_pays_page.dart';
import 'package:Bubble/scene/instructional_video_dialogue_page.dart';
import 'package:Bubble/scene/teaching_dialogue_page.dart';
import 'package:Bubble/tabmain/main_tabber.dart';
import 'package:Bubble/home/page/course_purchase_page.dart';
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
  static String coursePurchasePage = '/CoursePurchasePage';
  static String coursePaysPage = '/CoursePaysPage';
  static String instructionalVideoDialoguePage =
      '/InstructionalVideoDialoguePage';
  static String teachingDialoguePage = '/TeachingDialoguePage';

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

    router.define(coursePurchasePage,
        handler: Handler(handlerFunc: (_, __) => const CoursePurchasePage()));

    router.define(coursePaysPage,
        handler: Handler(handlerFunc: (_, __) => const CoursePaysPage()));

    router.define(scenePage,
        handler: Handler(
            handlerFunc: (_, __) => ScenePage(
                  onEnd: () {},
                )));

    router.define(instructionalVideoDialoguePage,
        handler: Handler(
            handlerFunc: (_, __) => InstructionalVideoDialoguePage(
                  onEnd: () {},
                )));

    router.define(teachingDialoguePage,
        handler: Handler(
            handlerFunc: (_, __) => TeachingDialoguePage(
                  onEnd: () {},
                )));
  }
}
