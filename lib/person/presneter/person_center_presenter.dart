
import 'package:flustars_flutter3/flustars_flutter3.dart';

import '../../constant/constant.dart';
import '../../login/entity/user_info_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../view/person_center_view.dart';

class PersonalCenterPresenter extends BasePagePresenter<PersonCenterView>{

  @override
  void initState() {
    super.initState();
    SpUtil.getObj(Constant.userInfoKey, (v){
      if(v.isNotEmpty&& v is UserInfoDataData){
            view.getUserInfo(v as UserInfoDataData);
      }
    });
  }

}