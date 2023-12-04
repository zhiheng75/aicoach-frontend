

import 'package:flustars_flutter3/flustars_flutter3.dart';

import '../../constant/constant.dart';
import '../../login/entity/login_info_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/study_info_entity.dart';
import '../view/person_center_view.dart';

class PersonalCenterPresenter extends BasePagePresenter<PersonCenterView>{

  @override
  void initState() {
    super.initState();
    SpUtil.getObj(Constant.userInfoKey, (v) => {
    if (v.isNotEmpty) {
        view.getUserInfo(LoginInfoDataData.fromJson(v))
  }
    });
    getStudyInfo();
  }


  Future getStudyInfo(){
    return requestNetwork<StudyInfoData>(Method.get,
        url: HttpApi.studyInfo, isShow: false, onSuccess: (data) {
      if (data != null && data.code == 200) {
        view.getStudyReport(data.data);
      }
    });
  }
}