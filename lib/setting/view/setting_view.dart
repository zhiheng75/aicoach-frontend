import 'package:Bubble/mvp/mvps.dart';

import '../../login/entity/login_info_entity.dart';

abstract class SettingView implements IMvpView{

  void getUserInfo(LoginInfoDataData data);

  void sendSuccess(String s);

  void sendFail(String msg);

  void wechatSuccess();
  void wechatFail(String msg);
}