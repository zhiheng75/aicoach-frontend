
import '../../login/entity/login_info_entity.dart';
import '../../mvp/mvps.dart';

abstract class PersonCenterView implements IMvpView{

  void getUserInfo(LoginInfoDataData data);
}

