import 'package:Bubble/mvp/mvps.dart';
import 'package:Bubble/person/entity/goods_bean.dart';

abstract class UserMembershipUpgradePageView implements IMvpView {
  void sendSuccess(GoodsBean data);
  void sendFail(String msg);
  void paySuccess();
}
