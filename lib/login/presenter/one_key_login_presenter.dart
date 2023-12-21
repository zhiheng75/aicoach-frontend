import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
import '../entity/login_info_entity.dart';
import '../view/one_key_login_view.dart';

class OneKeyLoginPresenter extends BasePagePresenter<OneKeyLoginView>{


  Future sendKeyLoginToken(token){
    Map<String,String> map = {};
    map["loginToken"] = token;
    return requestNetwork<LoginInfoData>(Method.post,
        params: map,
        url: HttpApi.keyLogin, isShow: false, onSuccess: (data) {
          if (data != null){
            if (data.code == 200) {

              SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
              SpUtil.putString(Constant.accessToken, data.data.token);

              view.loginSuccess();
            }
          }
        });
  }
}