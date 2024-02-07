import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/view/mock_examination_two_view.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class MockExaminationTwoPagePresenter
    extends BasePagePresenter<MockExaminationTwoView> {
  Future postExamUpdate(Map<String, dynamic> map) {
    // map["answer"] = map["answer"].toString();

    return requestNetwork<ResultData>(Method.post,
        url: HttpApi.examUpdata,
        params: map,
        isShow: false, onSuccess: (result) {
      // Map<String, dynamic> examPermissionMap = json.decode(result.toString());
      // ExamPermissionBean examPermissioBean =
      //     ExamPermissionBean.fromJson(examPermissionMap);
      // Log.e("=============");
      // Log.e(examPermissioBean.data.leftTime.toString());
      // Log.e("=============");

      if (result != null && result.code == 200) {
        view.sendSuccess("");
      } else {
        view.sendFail("");
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
