

import 'package:Bubble/person/person_center_page.dart';
import 'package:Bubble/person/purchase_page.dart';
import 'package:Bubble/person/study_report.dart';
import 'package:fluro/fluro.dart';

import '../routers/i_router.dart';
import 'my_order_page.dart';

class MyOrderRouter implements IRouterProvider{

  static String myOrder = '/order';




  @override
  void initRouter(FluroRouter router) {
    router.define(myOrder, handler: Handler(handlerFunc: (_, __) => const MyOrderPage()));



  }

}