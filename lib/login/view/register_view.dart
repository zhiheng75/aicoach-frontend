import '../../mvp/mvps.dart';
import '../entity/wx_info_entity.dart';

abstract class RegisterView implements IMvpView{
  void wechatSuccess(WxInfoDataData data);
  void wechatFail();

  void hadBindWechat(WxInfoDataData data);

  void sendSmsSuccess();

  void loginSuccess();
}