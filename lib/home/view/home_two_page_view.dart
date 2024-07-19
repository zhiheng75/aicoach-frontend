import 'dart:ffi';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/home/entity/banner_list_bean.dart';

import '../../mvp/mvps.dart';

abstract class HomeTwoPageView implements IMvpView {
  void sendCharacterListSuccess(CharacterListBean data);
  void sendBannerListSuccess(BannerListBean data);
  void sendBindTeacherStatusSuccess(int data);

  void sendFail(String msg);

  void sendError();
}
