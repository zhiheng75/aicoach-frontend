import 'package:Bubble/person/entity/order_list_bean.dart';

import '../../mvp/mvps.dart';

abstract class CourseOrderView implements IMvpView {
  void sendSuccess(OrderListBean msg);
  void sendFail(String msg);
}
