import 'package:Bubble/person/page/course_order_page.dart';
import 'package:Bubble/report/page/my_examination_page.dart';
import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'report.dart';
import 'report_detail.dart';

class ReportRouter implements IRouterProvider {
  static String reportPage = '/report';
  static String reportDetailPage = '/reportDetail';
  static String myExaminationPage = '/MyExaminationPage';
  static String courseOrderPage = '/CourseOrderPage';

  @override
  void initRouter(FluroRouter router) {
    router.define(
      reportPage,
      handler: Handler(
        handlerFunc: (_, __) => const ReportPage(),
      ),
    );

    router.define(
      courseOrderPage,
      handler: Handler(
        handlerFunc: (_, __) => const CourseOrderPage(),
      ),
    );

    router.define(
      reportDetailPage,
      handler: Handler(
        handlerFunc: (context, __) {
          String sessionId = '';
          if (context != null &&
              context.settings != null &&
              context.settings!.arguments != null) {
            sessionId = (context.settings!.arguments!
                as Map<String, dynamic>)['sessionId'];
          }
          return ReportDetailPage(
            sessionId: sessionId,
          );
        },
      ),
    );

    // router.define(
    //   myExaminationPage,
    //   handler: Handler(
    //     handlerFunc: (_, __) => const MyExaminationPage(),
    //   ),
    // );

    router.define(myExaminationPage, handler: Handler(handlerFunc: (_, params) {
      String id = params['id']!.first;
      return MyExaminationPage(
        mockId: id,
      );
    }));
  }
}
