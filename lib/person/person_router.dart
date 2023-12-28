

import 'package:Bubble/person/person_center_page.dart';
import 'package:Bubble/person/purchase_page.dart';
import 'package:Bubble/person/study_report.dart';
import 'package:Bubble/person/suggestion_page.dart';
import 'package:fluro/fluro.dart';

import '../routers/i_router.dart';
import 'about.dart';
import 'order.dart';
import 'person.dart';

class PersonalRouter implements IRouterProvider{

  static String personalPurchase = '/personal/Purchase';
  static String personalStudyReport = '/personal/studyReport';
  static String personalCenter = '/personal/center';
  static String personalSuggestion = '/personal/Suggestion';

  static String person = '/person';
  static String order = '/order';
  static String about = '/about';

  @override
  void initRouter(FluroRouter router) {
    router.define(person, handler: Handler(handlerFunc: (_, __) => const PersonPage()));
    router.define(personalPurchase, handler: Handler(handlerFunc: (_, __) => const PurchasePage()));
    router.define(personalStudyReport, handler: Handler(handlerFunc: (_, __) => const StudyReportPage()));
    router.define(personalCenter, handler: Handler(handlerFunc: (_, __) => const PersonalCenterPage()));
    router.define(personalSuggestion, handler: Handler(handlerFunc: (_, __) => const SuggestionPage()));

    router.define(order, handler: Handler(handlerFunc: (_, __) => const OrderPage()));
    router.define(about, handler: Handler(handlerFunc: (_, __) => const AboutPage()));
  }

}