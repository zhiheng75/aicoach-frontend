import 'package:Bubble/mvp/mvps.dart';
import 'package:Bubble/person/entity/get_pay_code_bean.dart';

abstract class XueersiPurchasePageView implements IMvpView {
  void sendQueryOrderSuccess(String status);

  void sendSuccess(GetPayCodeBean getPayCodeBean);
  void sendFail(String msg);
}
