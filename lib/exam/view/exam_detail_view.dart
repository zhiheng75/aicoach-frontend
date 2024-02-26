import 'package:Bubble/exam/entity/exam_detail_bean.dart';

import '../../mvp/mvps.dart';

abstract class ExamDetailView implements IMvpView {
  void sendSuccess(ExamDetailBean examDetailBean);
  void sendFail(String msg);

  void playAendSuccess(String msg);
}
