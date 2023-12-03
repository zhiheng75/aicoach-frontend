import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../login/entity/login_info_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../mvp/base_presenter.dart';
import '../../net/http_api.dart';
import '../view/setting_view.dart';
import '../../net/dio_utils.dart';

class SettingPresenter extends BasePagePresenter<SettingView>{

  bool hasBindWX = false;
  bool hasBindPhone = false;
  late LoginInfoDataData userInfo;

  @override
  void initState() {
    super.initState();
    SpUtil.getObj(Constant.userInfoKey, (v) => {
      if (v.isNotEmpty) {
        userInfo = LoginInfoDataData.fromJson(v),
         hasBindPhone= (userInfo.phone!=null ||userInfo.phone.isNotEmpty),
        hasBindWX = (userInfo.nickname!=null ||userInfo.nickname.isNotEmpty),
        view.getUserInfo(userInfo),
      }
    });
  }


  Future unbindWx(){
    // final Map<String, dynamic> params = <String, dynamic>{};
    // params['platform'] = "android";
    return requestNetwork(Method.post,
        url: HttpApi.unbindWX,
        isShow: true, onSuccess: (data) {

        });
  }

  Future getUpdate() {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['platform'] = "android";
    return requestNetwork(Method.get,
        url: HttpApi.updateApp,
        queryParameters: params,
        isShow: true, onSuccess: (data) {

        });

  }


}