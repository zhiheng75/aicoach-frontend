import 'package:Bubble/course/entity/step_detail_bean.dart';

import '../../mvp/mvps.dart';

abstract class CourseFlowPageView implements IMvpView {
  void sendSuccess(StepDetailBean stepDetailBean);
  void sendFail(String msg);
}
