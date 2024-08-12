import 'package:Bubble/mvp/mvps.dart';
import 'package:Bubble/person/entity/goods_v_bean.dart';

abstract class CourseSpeakingPurchaseView implements IMvpView {
  void sendSuccess(GoodsVBean goodsBean);
  void sendFail(String msg);

  void paySuccess();
}
