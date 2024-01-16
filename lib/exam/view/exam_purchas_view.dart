import '../../mvp/mvps.dart';
import 'package:Bubble/exam/entity/goods_list_bean.dart';

abstract class ExamPurchaseView implements IMvpView {
  void sendSuccess(GoodsListBean msg);
  void sendFail(String msg);
}
