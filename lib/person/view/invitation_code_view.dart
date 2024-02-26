import '../../mvp/mvps.dart';

abstract class InvitationCodeView implements IMvpView {
  void sendSuccess(String ms);
  void sendFail(String msg);
}
