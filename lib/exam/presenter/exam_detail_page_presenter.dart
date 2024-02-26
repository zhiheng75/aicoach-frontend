import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/exam_detail_bean.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/log_utils.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/exam_detail_view.dart';

class ExamDetailPagePresenter extends BasePagePresenter<ExamDetailView> {
  Future getExamDetail(String id) {
    final Map<String, String> params = <String, String>{};
    params["id"] = id;
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.examDetail,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> examDetailBeanMap = json.decode(result.toString());
      ExamDetailBean examDetailBean =
          ExamDetailBean.fromJson(examDetailBeanMap);
      Log.e("=============");
      Log.e(examDetailBean.data.toString());
      Log.e("=============");

      if (examDetailBean != null) {
        view.sendSuccess(examDetailBean);
      } else {
        view.sendFail("");
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }

  Future getGenerateAudio(String text) {
    final Map<String, String> params = <String, String>{};
    params["text"] = text;
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.generateAudio,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      if (result == null ||
          result.data == null ||
          (result.data as Map<String, dynamic>)['speech_url'] == null) {
        return;
      }
      Map<String, dynamic> data = result.data as Map<String, dynamic>;
      if (result.code == 200) {
        view.playAendSuccess(data['speech_url']);
      } else {
        view.sendFail("");
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
