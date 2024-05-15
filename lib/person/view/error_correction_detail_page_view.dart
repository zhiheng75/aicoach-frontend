import 'package:Bubble/person/entity/mistake_details_bean.dart';

import '../../mvp/mvps.dart';

abstract class ErrorCorrectionDetailPageView implements IMvpView {
  void sendSuccess(MistakeDetailsBean data);
  void sendFail(String msg);

  void sendSuggestAnsweSuccess(String standardAnswerStr, String speechUrlStr);
}
