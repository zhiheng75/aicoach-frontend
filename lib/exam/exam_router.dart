import 'package:Bubble/exam/entity/exam_step_bean.dart';
import 'package:Bubble/exam/page/mock_examination_one_page.dart';
import 'package:Bubble/exam/page/mock_examination_two_page.dart';
import 'package:Bubble/exam/page/mock_examinationend_one_page.dart';
import 'package:Bubble/exam/page/mock_examinationend_two_page.dart';
import 'package:Bubble/exam/page/mock_test_purchase_page.dart';
import 'package:Bubble/login/entity/login_info_entity.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../routers/i_router.dart';
import 'exam_detail.dart';

class ExamRouter implements IRouterProvider {
  static String examDetailPage = '/examDetail';

  static String mockExaminationOnePage = '/MockExaminationOnePage';
  static String mockExaminationTwoPage = '/MockExaminationTwoPage';
  static String mockExaminationendOnePage = '/MockExaminationendOnePage';
  static String mockExaminationendTwoPage = '/MockExaminationendTwoPage';
  static String mockTestPurchasePage = '/MockTestPurchasePage';

  @override
  void initRouter(FluroRouter router) {
    router.define(
      examDetailPage,
      handler: Handler(
        handlerFunc: (_, __) {
          return const ExamDetailPage(
            id: 1,
          );
        },
      ),
    );

    // router.define(mockExaminationOnePage,
    //     handler:
    //         Handler(handlerFunc: (_, __) => const MockExaminationOnePage()));

    router.define(mockExaminationOnePage,
        handler: Handler(handlerFunc: (_, params) {
      String state = params['state']!.first;

      return MockExaminationOnePage(state: int.parse(state));
    }));

    // router.define(mockExaminationTwoPage,
    //     handler:
    //         Handler(handlerFunc: (_, __) => const MockExaminationTwoPage()));

    router.define(mockExaminationTwoPage,
        handler: Handler(handlerFunc: (context, params) {
      // ExamStepBean examStepBean

      // if (context != null) {
      String state = params['state']!.first;

      ExamStepBean entity =
          ModalRoute.of(context!)?.settings.arguments as ExamStepBean;
      // }
      return MockExaminationTwoPage(
        entity: entity,
        state: int.parse(state),
      );
    }));

    // router.define(mockExaminationendOnePage,
    //     handler:
    //         Handler(handlerFunc: (_, __) => const MockExaminationendOnePage()));

    router.define(mockExaminationendOnePage,
        handler: Handler(handlerFunc: (_, params) {
      String id = params['id']!.first;
      return MockExaminationendOnePage(
        mockId: id,
      );
    }));

    // router.define(mockExaminationendTwoPage,
    //     handler:
    //         Handler(handlerFunc: (_, __) => const MockExaminationendTwoPage()));
    router.define(mockExaminationendTwoPage,
        handler: Handler(handlerFunc: (_, params) {
      String id = params['id']!.first;
      return MockExaminationendTwoPage(
        mockId: id,
      );
    }));
    router.define(mockTestPurchasePage,
        handler: Handler(handlerFunc: (_, __) => const MockTestPurchasePage()));
  }
}
