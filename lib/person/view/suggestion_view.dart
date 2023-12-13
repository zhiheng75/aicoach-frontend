import 'package:Bubble/mvp/mvps.dart';

import '../entity/send_img_result_entity.dart';

abstract class SuggestionView implements IMvpView{
  void sendSuccess();
  void sendFail(String msg);

  void sendImgSuccess(List<SendImgResultDataData> mList);
  void sendImgFail();
}