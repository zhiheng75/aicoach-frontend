import 'package:fluro/fluro.dart';
import '../routers/i_router.dart';
import 'exam_detail.dart';

class ExamRouter implements IRouterProvider{

  static String examDetailPage = '/examDetail';
  
  @override
  void initRouter(FluroRouter router) {
    router.define(
      examDetailPage,
      handler: Handler(
        handlerFunc: (_, __) {
          print('_:$_');
          print('__:$__');
          return ExamDetailPage(
            id: 1,
          );
        },
      ),
    );
  }
  
}
