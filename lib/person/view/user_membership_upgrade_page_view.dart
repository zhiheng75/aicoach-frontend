import 'package:Bubble/mvp/mvps.dart';
import 'package:Bubble/person/entity/goods_bean.dart';
import 'package:Bubble/person/entity/member_state_bean.dart';

abstract class UserMembershipUpgradePageView implements IMvpView {
  void sendSuccess(GoodsBean data);
  void sendMemberStateSuccess(MemberStateBean data);
  void sendSuccessMsg(String title, String msg);

  void sendFail(String msg);
  void paySuccess();
}
