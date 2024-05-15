import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/mistake_details_bean.dart';
import 'package:Bubble/person/view/error_correction_detail_page_view.dart';

class ErrorCorrectionDetailPagePresenter
    extends BasePagePresenter<ErrorCorrectionDetailPageView> {
  Future getMistakeDetails(String lessonId) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['lesson_id'] = lessonId;
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.mistakeDetails,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> mistakeRecordsBeanMap =
          json.decode(result.toString());
      MistakeDetailsBean mistakeDetailsBean =
          MistakeDetailsBean.fromJson(mistakeRecordsBeanMap);
      if (mistakeDetailsBean.code == 200) {
        view.sendSuccess(mistakeDetailsBean);
      } else {
        view.sendFail(mistakeDetailsBean.msg);
      }
    });
  }

  Future postSuggestAnswer(String question) async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['question'] = question;
    return requestNetwork<ResultData>(Method.post,
        url: HttpApi.suggestAnswer,
        params: params,
        isShow: true, onSuccess: (result) {
      if (result == null || result.data == null) {
        return;
      }
      String standardAnswer;
      String speechUrl;

      Map<String, dynamic> data = result.data as Map<String, dynamic>;
      standardAnswer =
          data['text'] != null && data['text'] != '' ? data['text'] : '暂无地道表达';
      speechUrl = data['speech_url'] != null && data['speech_url'] != ''
          ? data['speech_url']
          : '';
      view.sendSuggestAnsweSuccess(standardAnswer, speechUrl);
    }, onError: (code, msg) {
      // state = 'fail';
      // setState(() {});
    });
  }
}
