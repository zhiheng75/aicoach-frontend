import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/entity/lesson_feedback_detail_bean.dart';
import 'package:Bubble/course/entity/lesson_list_bean.dart';
import 'package:Bubble/course/view/course_home_page_view.dart';
import 'package:Bubble/course/view/curriculum_evaluation_page_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class CurriculumEvaluationPagePresenter
    extends BasePagePresenter<CurriculumEvaluationPageView> {
  // @override
  // void afterInit() {
  //   // TODO: implement afterInit
  //   super.afterInit();
  // }
  Future getLessonFeedbackDetail(
    String lessonId,
  ) {
    final Map<String, String> params = <String, String>{};
    params["lesson_id"] = lessonId;

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.lessonFeedbackDetail,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> lessonFeedbackDetailMap =
          json.decode(result.toString());
      LessonFeedbackDetailBean lessonFeedback =
          LessonFeedbackDetailBean.fromJson(lessonFeedbackDetailMap);

      if (lessonFeedback.code == 200) {
        view.sendLessonFeedbackDetailSuccess(lessonFeedback);
      } else {
        view.sendFail(lessonFeedback.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }

  Future postLessonFeedback(
    String lessonId,
    String anonymous,
    String star,
    String feedback,
  ) {
    final Map<String, String> params = <String, String>{};
    params["lesson_id"] = lessonId;
    params["anonymous"] = anonymous;
    params["star"] = star;
    params["feedback"] = feedback;

    return requestNetwork<ResultData>(Method.post,
        url: HttpApi.lessonFeedback,
        params: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> lessonFeedbackMap = json.decode(result.toString());
      ResultData lessonFeedback = ResultData.fromJson(lessonFeedbackMap);

      if (lessonFeedback.code == 200) {
        view.sendSuccess(lessonFeedback.msg);
      } else {
        view.sendFail(lessonFeedback.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
