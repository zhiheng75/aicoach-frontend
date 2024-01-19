import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/exam_step_bean.dart';
import 'package:Bubble/exam/view/mock_examination_view.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/log_utils.dart';

import '../../mvp/base_page_presenter.dart';

class ExamExaminationPagePresenter
    extends BasePagePresenter<MockExaminationView> {
  @override
  void afterInit() {
    super.afterInit();
    getExamStep();
  }

  Future getExamStep() {
    final Map<String, String> params = <String, String>{};

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.examStep,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Log.e(result.toString());
      Map<String, dynamic> examStepBeanMap = json.decode(result.toString());
      ExamStepBean examStepBean = ExamStepBean.fromJson(examStepBeanMap);
      if (examStepBean != null) {
        view.sendSuccess(examStepBean);
      } else {
        view.sendFail("失败");
      }
    }, onError: (code, msg) {
      view.sendFail("失败");
    });
  }
}
