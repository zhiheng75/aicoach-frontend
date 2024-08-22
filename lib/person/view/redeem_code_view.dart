import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/person/entity/redeem_code_bean.dart';
import 'package:Bubble/person/entity/redeem_list_bean.dart';

import '../../mvp/mvps.dart';

abstract class RedeemCodeView implements IMvpView {
  void sendSuccess(RedeemListBean data);
  void sendCodeSuccess(DataCode data);

  void sendFail(String msg);
  void sendCodeFail(String msg);
}
