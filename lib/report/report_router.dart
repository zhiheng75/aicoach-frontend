import 'package:fluro/fluro.dart';
import 'package:spokid/report/my_report_page.dart';
import 'package:spokid/setting/theme_page.dart';

import '../routers/i_router.dart';

class MyReportRouter implements IRouterProvider{

  static String myReportPage = '/report';


  
  @override
  void initRouter(FluroRouter router) {
    router.define(myReportPage, handler: Handler(handlerFunc: (_, __) => const MyReportPage()));


  }
  
}
