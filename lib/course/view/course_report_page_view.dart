import 'package:Bubble/course/entity/lesson_report_detail_bean.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';

import '../../mvp/mvps.dart';

abstract class CourseReportPageView implements IMvpView {
  void sendSuccess(LessonReportDetailBean data);
  void sendFail(String msg);
}
