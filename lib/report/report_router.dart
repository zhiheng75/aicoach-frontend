import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'report.dart';
import 'report_detail.dart';

class ReportRouter implements IRouterProvider{

  static String reportPage = '/report';
  static String reportDetailPage = '/reportDetail';
  
  @override
  void initRouter(FluroRouter router) {
    router.define(
      reportPage,
      handler: Handler(
        handlerFunc: (_, __) => const ReportPage(),
      ),
    );

    router.define(
      reportDetailPage,
      handler: Handler(
        handlerFunc: (_, __) {
          print('_:$_');
          print('__:$__');
          return ReportDetailPage(
            id: 1,
          );
        },
      ),
    );
  }
  
}
