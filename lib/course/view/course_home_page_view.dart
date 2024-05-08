import 'package:Bubble/course/entity/lesson_list_bean.dart';

import '../../mvp/mvps.dart';

abstract class CourseHomePageView implements IMvpView {
  void sendSuccess(LessonListBean data);
  void sendFail(String msg);
}
