import 'package:Bubble/exam/entity/exam_step_bean.dart';

import '../../mvp/mvps.dart';

abstract class MockExaminationView implements IMvpView {
  void sendSuccess(ExamStepBean examStepBean);
  void sendFail(String msg);
}
