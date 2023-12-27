import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'report.dart';

class ReportRouter implements IRouterProvider{

  static String reportPage = '/report';
  
  @override
  void initRouter(FluroRouter router) {
    router.define(
      reportPage,
      handler: Handler(
        handlerFunc: (_, __) => ReportPage(),
      ),
    );
  }
  
}
