import '../../mvp/mvps.dart';

abstract class ExamView implements IMvpView {
  void sendSuccess(int leftTime, int state);
  void sendFail(String msg);
}
