import 'package:Bubble/entity/result_entity.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import '../../constant/constant.dart';
import '../../login/entity/login_info_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/device_utils.dart';
import '../entity/study_info_entity.dart';
import '../view/person_center_view.dart';

class PersonalCenterPresenter extends BasePagePresenter<PersonCenterView>{


  @override
  void afterInit() {
    super.afterInit();
    getAvailableTime();
    getUserInfo();
    getStudyInfo();
  }


  Future getAvailableTime() async {
    String deviceId = await Device.getDeviceId();
    return requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.permission,
      queryParameters: {
        'device_id': deviceId,
      },
      onSuccess: (result) {
        Map<String, dynamic> data = {
          'left_time': 0,
          'is_member': 0,
        };
        if (result != null && result.code == 200 && result.data != null) {
          data = result.data as Map<String, dynamic>;
        }
        view.getAvailableTime(data);
      }
    );
  }


  Future getUserInfo(){
    return requestNetwork<LoginInfoData>(Method.get,
        url: HttpApi.userInfo,  onSuccess: (data) {
          if (data != null && data.code == 200) {
            SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
            view.getUserInfo(data.data);
          }
        });
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