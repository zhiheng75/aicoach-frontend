import 'package:Bubble/login/entity/new_wx_entity.dart';

import '../../mvp/mvps.dart';
import '../entity/login_info_entity.dart';

abstract class RegisterView implements IMvpView {
  //微信登录成功但是没绑定
  void wechatSuccess(LoginInfoDataData data);
  void wechatFail();

  void hadBindWechat();

  void sendSmsSuccess();

  // void loginSuccess(UserInfoDataData date);

  // void loginSuccess(MyUserInfo myUserInfo);
  void loginSuccess();
  // void loginError(String msg);

  void newwechatSuccess(NewWxInfoBeanData data);
}
