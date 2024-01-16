import '../../mvp/mvps.dart';

abstract class ExamView implements IMvpView {
  void sendSuccess(int leftTime);
  void sendFail(String msg);
}
