import 'package:Bubble/course/entity/lesson_feedback_detail_bean.dart';

import '../../mvp/mvps.dart';

abstract class CurriculumEvaluationPageView implements IMvpView {
  void sendSuccess(String msg);
  void sendFail(String msg);
  void sendLessonFeedbackDetailSuccess(LessonFeedbackDetailBean data);
}
