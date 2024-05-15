import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/mistake_records_bean.dart';
import 'package:Bubble/person/view/error_correction_page_view.dart';

class ErrorCorrectionPagePresenter
    extends BasePagePresenter<ErrorCorrectionPageView> {
  @override
  void afterInit() {
    super.afterInit();
    getMistakeRecordslist();
  }

  Future getMistakeRecordslist() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.mistakeRecords,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> mistakeRecordsBeanMap =
          json.decode(result.toString());
      MistakeRecordsBean mistakeRecordsBean =
          MistakeRecordsBean.fromJson(mistakeRecordsBeanMap);
      if (mistakeRecordsBean.code == 200) {
        view.sendSuccess(mistakeRecordsBean);
      } else {
        view.sendFail(mistakeRecordsBean.msg);
      }
    });
  }
}
