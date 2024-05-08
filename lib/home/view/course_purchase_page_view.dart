import 'package:Bubble/home/entity/lesson_detail_bean.dart';

import '../../mvp/mvps.dart';

abstract class CoursePurchasePageView implements IMvpView {
  void sendSuccess(LessonDetailBean data);
  void sendFail(String msg);
}
