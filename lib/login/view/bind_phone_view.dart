
import '../../mvp/mvps.dart';

abstract class BindPhoneView implements IMvpView{
  void sendSuccess(String msg);
  void sendFail(String msg);

  void wechatLoginSuccess(String msg);
  void wechatLoginFail(String msg);
}