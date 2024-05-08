import 'package:Bubble/chat/entity/character_list_bean.dart';

import '../../mvp/mvps.dart';

abstract class SwitchingTeacherPageView implements IMvpView {
  void sendSuccess(CharacterListBean characterListBean);
  void sendFail(String msg);
}
