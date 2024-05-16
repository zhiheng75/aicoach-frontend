import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/scene/view/instructional_video_dialogue_view.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/notification_utils.dart';

class InstructionalVideoDialoguePresenter
    extends BasePagePresenter<InstructionalVideoDialogueView> {
  Future postStepUpdate(String lessonId, String stepId) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params["level_id"] = lessonId;
    params["step_id"] = stepId;
    params["complated"] = "1";

    return requestNetwork<ResultData>(Method.post,
        url: HttpApi.stepUpdate,
        params: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> resultDataMap = json.decode(result.toString());
      ResultData resultData = ResultData.fromJson(resultDataMap);
      if (resultData.code == 200) {
        EventBus().emit(NotificationUtils.nextResetChat);
        view.sendSuccess(resultData.msg);
      } else {
        view.sendFail(resultData.msg);
      }
    });
  }
}
