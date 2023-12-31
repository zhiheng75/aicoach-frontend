import 'package:fluro/fluro.dart';

import '../routers/i_router.dart';
import 'about.dart';
import 'order.dart';
import 'person.dart';
import 'purchase.dart';
import 'setting.dart';
import 'suggestion_page.dart';

class PersonalRouter implements IRouterProvider{

  static String purchase = '/purchase';
  static String setting = '/setting';
  static String personalSuggestion = '/personal/Suggestion';

  static String person = '/person';
  static String order = '/order';
  static String about = '/about';

  @override
  void initRouter(FluroRouter router) {
    router.define(person, handler: Handler(handlerFunc: (_, __) => const PersonPage()));
    router.define(setting, handler: Handler(handlerFunc: (_, __) => const SettingPage()));
    router.define(purchase, handler: Handler(handlerFunc: (_, __) => const PurchasePage()));
    router.define(order, handler: Handler(handlerFunc: (_, __) => const OrderPage()));
    router.define(personalSuggestion, handler: Handler(handlerFunc: (_, __) => const SuggestionPage()));
    router.define(about, handler: Handler(handlerFunc: (_, __) => const AboutPage()));
  }

}