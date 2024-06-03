import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/home/page/entity/base_config_entity.dart';
import 'package:Bubble/home/page/entity/lesson_detail_bean.dart';
import 'package:Bubble/home/view/course_purchase_page_view.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class CoursePurchasePagePresenter
    extends BasePagePresenter<CoursePurchasePageView> {
  @override
  void afterInit() {
    // TODO: implement afterInit
    super.afterInit();
    // getLessonDetail("1");
  }

  Future getLessonDetail(String levelId) {
    final Map<String, String> params = <String, String>{};
    params["level_id"] = levelId;

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.lessonDetail,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> lessonDetailMap = json.decode(result.toString());
      LessonDetailBean lessonDetailBean =
          LessonDetailBean.fromJson(lessonDetailMap);

      if (lessonDetailBean.code == 200) {
        view.sendSuccess(lessonDetailBean);
      } else {
        view.sendFail(lessonDetailBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
