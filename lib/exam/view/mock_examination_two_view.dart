import '../../mvp/mvps.dart';

abstract class MockExaminationTwoView implements IMvpView {
  void sendSuccess(String msg);
  void sendFail(String msg);
}
