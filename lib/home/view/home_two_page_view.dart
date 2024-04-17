import 'package:Bubble/chat/entity/character_list_bean.dart';

import '../../mvp/mvps.dart';

abstract class HomeTwoPageView implements IMvpView {
  void sendCharacterListSuccess(CharacterListBean data);
  void sendFail(String msg);
}
