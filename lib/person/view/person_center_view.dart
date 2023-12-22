
import '../../login/entity/login_info_entity.dart';
import '../../mvp/mvps.dart';
import '../entity/study_info_entity.dart';

abstract class PersonCenterView implements IMvpView{

  void getAvailableTime(Map<String, dynamic> data);

  void getUserInfo(LoginInfoDataData data);

  void getStudyReport(StudyInfoDataData data);
}

