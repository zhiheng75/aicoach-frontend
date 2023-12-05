import 'package:Bubble/mvp/mvps.dart';

abstract class SuggestionView implements IMvpView{
  void sendSuccess();
  void sendFail(String msg);
}