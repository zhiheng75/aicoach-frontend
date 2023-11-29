
import '../../login/entity/user_info_entity.dart';
import '../../mvp/mvps.dart';

abstract class PersonCenterView implements IMvpView{

  void getUserInfo(UserInfoDataData data);
}

