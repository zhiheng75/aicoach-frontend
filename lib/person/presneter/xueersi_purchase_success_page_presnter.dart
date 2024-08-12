import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/bind_teacher_bean.dart';
import 'package:Bubble/person/view/xueersi_purchase_success_page_view.dart';

class XueersiPurchaseSuccessPagePresenter
    extends BasePagePresenter<XueersiPurchaseSuccessPageView> {
  @override
  void afterInit() {
    super.afterInit();
    getbindTeacherDetail();
  }

  Future getbindTeacherDetail() {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.bindTeacher, isShow: false, onSuccess: (result) {
      Map<String, dynamic> bindTeacherBeanMap = json.decode(result.toString());
      BindTeacherBean bindTeacherBean =
          BindTeacherBean.fromJson(bindTeacherBeanMap);

      if (bindTeacherBean.code == 200) {
        view.sendSuccess(bindTeacherBean);
      } else {
        view.sendFail(bindTeacherBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
