import 'package:Bubble/mvp/mvps.dart';

abstract class InstructionalVideoDialogueView implements IMvpView {
  void sendSuccess(String data);
  void sendFail(String msg);
}
