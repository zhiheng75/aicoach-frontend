

import 'package:fluro/fluro.dart';
import 'package:spokid/person/purchase_page.dart';

import '../routers/i_router.dart';

class PersonalRouter implements IRouterProvider{

  static String personalPurchase = '/personalPurchase';



  @override
  void initRouter(FluroRouter router) {
    router.define(personalPurchase, handler: Handler(handlerFunc: (_, __) => const PurchasePage()));


  }

}