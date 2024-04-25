import 'package:Bubble/course/page/course_details_page.dart';
import 'package:Bubble/course/page/course_flow_page.dart';
import 'package:Bubble/course/page/course_report_page.dart';
import 'package:Bubble/course/page/curriculum_evaluation_page.dart';
import 'package:Bubble/routers/i_router.dart';
import 'package:fluro/fluro.dart';

class CourseRouter implements IRouterProvider {
  static String courseFlowPage = '/CourseFlowPage';
  static String courseDetailsPage = '/CourseDetailsPage';
  static String courseReportPage = '/CourseReportPage';
  static String curriculumEvaluationPage = '/CurriculumEvaluationPage';

  @override
  void initRouter(FluroRouter router) {
    // router.define(homePage, handler: Handler(handlerFunc: (_, params) {
    //   //人物
    //   String index = params['index']!.first;
    //   int idx = int.parse(index);
    //   return HomeNewPage(index: idx);
    // }));

    router.define(courseFlowPage,
        handler: Handler(handlerFunc: (_, __) => const CourseFlowPage()));

    router.define(courseDetailsPage,
        handler: Handler(handlerFunc: (_, __) => const CourseDetailsPage()));

    router.define(courseReportPage,
        handler: Handler(handlerFunc: (_, __) => const CourseReportPage()));

    router.define(curriculumEvaluationPage,
        handler:
            Handler(handlerFunc: (_, __) => const CurriculumEvaluationPage()));
  }
}
