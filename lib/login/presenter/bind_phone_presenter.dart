import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../entity/empty_response_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/login_info_entity.dart';
import '../view/bind_phone_view.dart';

class BindPhonePresenter extends BasePagePresenter<BindPhoneView> {

  late LoginInfoDataData data;

  Future sendSms(String phoneNum) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['phone'] = phoneNum;
    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.smsLogin,
        queryParameters: params,
        isShow: true, onSuccess: (data) {
          if (data != null) {
            if (data.code == 200) {
              view.sendSuccess("发送成功");
            } else {
              view.sendFail(data.msg);
            }
          } else {
            view.sendFail("响应异常");
          }
        });
  }

  Future toBind(String phoneNum, String smsCode) {
    Options op = Options();
    op.contentType = "application/json";
    Map<String, dynamic> params = {};
    params['phone'] = phoneNum;
    params['code'] = smsCode;
    params['openid'] = data.openid;
    params['nickname'] = data.nickname;
    params['headimgurl'] = data.headimgurl;
    params['sex'] = data.sex;
    params['city'] = data.city;
    params['country'] = data.country;
    params['province'] = data.province;
    params['unionid'] = data.unionid;


    return requestNetwork<LoginInfoData>(Method.post,
        url: HttpApi.wechatLogin,
        params: params,
        options: op,
        isShow: true,
        onSuccess: (data) {
          if (data != null) {
            if (data.code == 200) {

              SpUtil.putObject(Constant.userInfoKey, data.data);
              SpUtil.putString(Constant.accessToken, data.data.token);
              view.wechatLoginSuccess("登录成功");
            } else {
              view.wechatLoginFail(data.msg);
            }
          }
        });
  }

}