import 'package:Bubble/exam/page/mock_examination_one_page.dart';
import 'package:Bubble/exam/page/mock_examination_two_page.dart';
import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'exam_detail.dart';

class ExamRouter implements IRouterProvider {
  static String examDetailPage = '/examDetail';

  static String mockExaminationOnePage = '/MockExaminationOnePage';
  static String mockExaminationTwoPage = '/MockExaminationTwoPage';

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

    router.define(mockExaminationOnePage,
        handler:
            Handler(handlerFunc: (_, __) => const MockExaminationOnePage()));

    router.define(mockExaminationTwoPage,
        handler:
            Handler(handlerFunc: (_, __) => const MockExaminationTwoPage()));
  }
}
