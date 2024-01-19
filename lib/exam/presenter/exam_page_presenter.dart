import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/exam_permission_bean.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/log_utils.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/exam_view.dart';

class ExamPagePresenter extends BasePagePresenter<ExamView> {
  // @override
  // void afterInit() {
  //   super.afterInit();
  //   getExamPermission();
  // }

  Future getExamPermission() {
    final Map<String, String> params = <String, String>{};

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.examPermission,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> examPermissionMap = json.decode(result.toString());
      ExamPermissionBean examPermissioBean =
          ExamPermissionBean.fromJson(examPermissionMap);
      Log.e("=============");
      Log.e(examPermissioBean.data.leftTime.toString());
      Log.e("=============");

      if (examPermissioBean != null) {
        view.sendSuccess(
            examPermissioBean.data.leftTime, examPermissioBean.data.status);
      } else {
        view.sendFail("");
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
