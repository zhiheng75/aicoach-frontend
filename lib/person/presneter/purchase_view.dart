import 'package:Bubble/mvp/mvps.dart';

import '../entity/my_good_list_entity.dart';
import '../entity/wx_pay_entity.dart';

abstract class PurchaseView implements IMvpView{

  void goodListData(List<MyGoodListEntity> bean);

  void getWXPayMsg(WxPayDataData bean);
}