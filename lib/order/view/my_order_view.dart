import 'package:Bubble/mvp/mvps.dart';

import '../entity/order_list_entity.dart';

abstract class MyOrderView implements IMvpView{
  void goodListData(List<OrderListDataData> data);

}