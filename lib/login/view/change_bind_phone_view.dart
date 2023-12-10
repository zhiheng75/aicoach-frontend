
import '../../mvp/mvps.dart';

abstract class ChangeBindPhoneView implements IMvpView{
  void sendSuccess(String msg);
  void sendFail(String msg);

  void bindSuccess(String msg);
  void bindFail(String msg);
}