import '../../mvp/mvps.dart';

abstract class LoginView implements IMvpView{
  void wechatSuccess(String token);
  void wechatFail();
}