import 'package:fluro/fluro.dart';
import 'package:Bubble/report/my_report_page.dart';
import 'package:flutter/cupertino.dart';

import '../person/entity/study_list_entity.dart';
import '../routers/i_router.dart';

class MyReportRouter implements IRouterProvider{

  static String myReportPage = '/report';


  
  @override
  void initRouter(FluroRouter router) {
    router.define(myReportPage, handler: Handler(handlerFunc:(context, params) {
      StudyListDataData entity = StudyListDataData();
      if(context!=null){
        entity = ModalRoute.of(context)?.settings.arguments as StudyListDataData;
      }
      return MyReportPage(entity);
    } ));


  }
  
}
