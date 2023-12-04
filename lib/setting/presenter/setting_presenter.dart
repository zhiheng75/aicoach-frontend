import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:dio/dio.dart';
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
              if (v.isNotEmpty)
                {
                  userInfo = LoginInfoDataData.fromJson(v),
                  hasBindPhone = userInfo.phone.isNotEmpty,
                  hasBindWX = userInfo.openid.isNotEmpty,
                  view.getUserInfo(userInfo),
                }
            });
  }


  Future unbindWx(){
    // final Map<String, dynamic> params = <String, dynamic>{};
    // params['platform'] = "android";
    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.unbindWX,
        isShow: true, onSuccess: (data) {
          if (data != null) {
            if (data.code == 200) {
              userInfo.openid="";
              SpUtil.putObject(Constant.userInfoKey, userInfo);
              hasBindWX = false;
              view.sendSuccess("解绑成功");
            } else {
              view.sendFail(data.msg);
            }
          } else {
            view.sendFail("响应异常");
          }
        });
  }


  Future getWxInfo(
      String wechatCode,
      ) {
    final Map<String, String> params = <String, String>{};
    params["code"] = wechatCode;
    params["platform"] = "app";

    return requestNetwork<LoginInfoData>(Method.get,
        url: HttpApi.wechatInfo,
        queryParameters: params,
        isShow: true,
        onSuccess: (data) {
          if(data!=null){
            bindWx(data.data);

          }else{
            view.wechatFail("微信登录失败");
          }

        });
  }


  Future bindWx(LoginInfoDataData data){
    Options op = Options();
    op.contentType = "application/json";
    Map<String, dynamic> params = {};
    params['id'] = userInfo.id;
    params['openid'] = data.openid;
    params['nickname'] = data.nickname;
    params['headimgurl'] = data.headimgurl;
    params['sex'] = data.sex;
    params['city'] = data.city;
    params['country'] = data.country;
    params['province'] = data.province;
    params['unionid'] = data.unionid;
    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.bindWX,
        isShow: true,
        params: params,
        onSuccess: (mData) {
          userInfo.openid = data.openid;
          if (mData != null) {
            if (mData.code == 200) {
              SpUtil.putObject(Constant.userInfoKey, userInfo);
              hasBindWX = true;
              view.sendSuccess("绑定成功");
            } else {
              view.sendFail(mData.msg);
            }
          } else {
            view.sendFail("响应异常");
          }
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