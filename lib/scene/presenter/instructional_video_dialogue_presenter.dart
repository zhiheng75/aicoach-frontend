import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/scene/view/instructional_video_dialogue_view.dart';

class InstructionalVideoDialoguePresenter
    extends BasePagePresenter<InstructionalVideoDialogueView> {
  Future postStepUpdate() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    return requestNetwork<ResultData>(Method.post,
        url: HttpApi.stepUpdate,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> resultDataMap = json.decode(result.toString());
      ResultData resultData = ResultData.fromJson(resultDataMap);
      if (resultData.code == 200) {
        view.sendSuccess(resultData.msg);
      } else {
        view.sendFail(resultData.msg);
      }
    });
  }
}
