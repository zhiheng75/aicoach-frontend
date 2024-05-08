import '../../mvp/mvps.dart';

abstract class InvitationCodeView implements IMvpView {
  void sendSuccess(String ms);
  void sendSuccessMsg(String title, String msg);

  void sendFail(String msg);
}
