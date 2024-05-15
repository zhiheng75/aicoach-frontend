import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/entity/lesson_list_bean.dart';
import 'package:Bubble/course/entity/lesson_report_detail_bean.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';
import 'package:Bubble/course/view/course_flow_page_view.dart';
import 'package:Bubble/course/view/course_report_page_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class CourseReportPagePresenter
    extends BasePagePresenter<CourseReportPageView> {
  // @override
  // void afterInit() {
  //   super.afterInit();
  //   getStepDetail();
  // }

  Future getStepDetail(String lessonId) {
    final Map<String, String> params = <String, String>{};
    params["lesson_id"] = lessonId;

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.lessonReportDetail,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> lessonReportDetailBeanMap =
          json.decode(result.toString());
      LessonReportDetailBean lessonReportDetailBean =
          LessonReportDetailBean.fromJson(lessonReportDetailBeanMap);

      if (lessonReportDetailBean.code == 200) {
        view.sendSuccess(lessonReportDetailBean);
      } else {
        view.sendFail(lessonReportDetailBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
