import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/entity/lesson_list_bean.dart';
import 'package:Bubble/course/view/course_home_page_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class CourseHomePagePresenter extends BasePagePresenter<CourseHomePageView> {
  @override
  void afterInit() {
    super.afterInit();
    getLessonList();
  }

  Future getLessonList() {
    final Map<String, String> params = <String, String>{};

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.lessonList,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> lessonListMap = json.decode(result.toString());
      LessonListBean lessonListBean = LessonListBean.fromJson(lessonListMap);

      if (lessonListBean.code == 200) {
        view.sendSuccess(lessonListBean);
      } else {
        view.sendFail(lessonListBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
