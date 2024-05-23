import 'package:Bubble/common/webview_not_nav_page.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/page/certified_learning_page.dart';
import 'package:Bubble/course/page/course_details_page.dart';
import 'package:Bubble/course/page/course_flow_page.dart';
import 'package:Bubble/course/page/course_report_page.dart';
import 'package:Bubble/course/page/curriculum_evaluation_page.dart';
import 'package:Bubble/course/page/switching_teacher_page.dart';
import 'package:Bubble/routers/i_router.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class CourseRouter implements IRouterProvider {
  static String courseFlowPage = '/CourseFlowPage';
  static String courseDetailsPage = '/CourseDetailsPage';
  static String courseReportPage = '/CourseReportPage';
  static String curriculumEvaluationPage = '/CurriculumEvaluationPage';
  static String switchingTeacherPage = '/SwitchingTeacherPage';

  static String certifiedLearningPage = '/CertifiedLearningPage';

  @override
  void initRouter(FluroRouter router) {
    // router.define(homePage, handler: Handler(handlerFunc: (_, params) {
    //   //人物
    //   String index = params['index']!.first;
    //   int idx = int.parse(index);
    //   return HomeNewPage(index: idx);
    // }));

    router.define(courseFlowPage,
        handler: Handler(handlerFunc: (context, params) {
      String lessonId = params['lessonId']!.first;
      return CourseFlowPage(
        lessonId: lessonId,
      );
    }));

    // router.define(courseFlowPage,
    //     handler: Handler(handlerFunc: (_, __) => const CourseFlowPage()));

    // router.define(courseDetailsPage,
    //     handler: Handler(handlerFunc: (_, __) => const CourseDetailsPage()));

    router.define(courseDetailsPage,
        handler: Handler(handlerFunc: (context, params) {
      StepDetailBean stepDetailBean =
          ModalRoute.of(context!)?.settings.arguments as StepDetailBean;
      // }
      return CourseDetailsPage(
        stepDetailBean: stepDetailBean,
      );
    }));

    router.define(courseReportPage,
        handler: Handler(handlerFunc: (context, params) {
      String lessonId = params['lessonId']!.first;
      return CourseReportPage(
        lessonId: lessonId,
      );
    }));

    router.define(switchingTeacherPage,
        handler: Handler(handlerFunc: (_, __) => const SwitchingTeacherPage()));
    router.define(certifiedLearningPage,
        handler:
            Handler(handlerFunc: (_, __) => const CertifiedLearningPage()));

    router.define(curriculumEvaluationPage,
        handler: Handler(handlerFunc: (context, params) {
      // ExamStepBean examStepBean

      // if (context != null) {
      // String state = params['state']!.first;

      StepDetailBean stepDetailBean =
          ModalRoute.of(context!)?.settings.arguments as StepDetailBean;
      // }
      return CurriculumEvaluationPage(
        stepDetailBean: stepDetailBean,
      );
    }));
  }
}
