import 'package:Bubble/mvp/mvps.dart';
import 'package:Bubble/person/entity/bind_teacher_bean.dart';

abstract class XueersiPurchaseSuccessPageView implements IMvpView {
  void sendSuccess(BindTeacherBean bindTeacherBean);
  void sendFail(String msg);
}
