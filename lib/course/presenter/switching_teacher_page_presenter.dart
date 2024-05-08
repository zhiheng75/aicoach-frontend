import 'dart:convert';

import 'package:Bubble/chat/entity/character_list_bean.dart';
import 'package:Bubble/course/view/switching_teacher_page_view.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';

class SwitchingTeacherPagePresenter
    extends BasePagePresenter<SwitchingTeacherPageView> {
  @override
  void afterInit() {
    super.afterInit();
    getTeacherTwoList();
  }

  Future getTeacherTwoList() {
    final Map<String, String> params = <String, String>{};

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.teacherTwoList,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> characterListMap = json.decode(result.toString());
      CharacterListBean teacherListBean =
          CharacterListBean.fromJson(characterListMap);

      if (teacherListBean.code == 200) {
        view.sendSuccess(teacherListBean);
      } else {
        view.sendFail(teacherListBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
