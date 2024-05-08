import '../../mvp/mvps.dart';

abstract class CurriculumEvaluationPageView implements IMvpView {
  void sendSuccess(String msg);
  void sendFail(String msg);
}
