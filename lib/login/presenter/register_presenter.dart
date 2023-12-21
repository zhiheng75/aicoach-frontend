import 'dart:convert';

import 'package:Bubble/util/toast_utils.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../entity/empty_response_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/login_info_entity.dart';
import '../entity/my_user_info_entity.dart';
import '../view/register_view.dart';


class RegisterPresenter extends BasePagePresenter<RegisterView>{

  Future sendSms(String phoneNum, bool isShowLoading) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['phone'] = phoneNum;

    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.smsLogin,
        queryParameters: params,
        isShow: isShowLoading, onSuccess: (data) {
      if (data != null&&data.code==200) {
        Toast.show("短信发送成功，请注意查收");
      }else{
        Toast.show("发送失败");
      }
    });
  }


  Future register(String phoneNum,String code, bool isShowLoading) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['phone'] = phoneNum;
    params['code'] = code;

    return requestNetwork<LoginInfoData>(Method.post,
        url: HttpApi.phoneLogin,
        queryParameters: params,
        isShow: isShowLoading, onSuccess: (data) {
      if (data != null) {
        if (data.code == 200) {
          Toast.show("登录成功");
          // MyUserInfoData myUserInfo = MyUserInfoData();
          // myUserInfo.id = data.data.id;
          // myUserInfo.email = data.data.email??"";
          // myUserInfo.openid = data.data.openid;
          // myUserInfo.nickname = data.data.nickname??"";
          // myUserInfo.sex = data.data.sex;
          // myUserInfo.province = data.data.province??"";
          // myUserInfo.country = data.data.country??"";
          // myUserInfo.headimgurl = data.data.headimgurl??"";
          // myUserInfo.unionid = data.data.unionid;
          // myUserInfo.school = data.data.school??"";
          // myUserInfo.token = data.data.token;
          // myUserInfo.createdAt = data.data.createdAt??"";
          // myUserInfo.name = data.data.name??"";
          // myUserInfo.phone = data.data.phone??"";
          // myUserInfo.city = data.data.city??"";
          // myUserInfo.description = data.data.description??"";
          // myUserInfo.updatedAt = data.data.updatedAt??"";

          SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
          SpUtil.putString(Constant.accessToken, data.data.token);

          view.loginSuccess();
        } else {
          Toast.show(data.msg);
        }
      }else{
        Toast.show("登录失败");
      }
    });
  }


  Future sendKeyLoginToken(token){
    Map<String,String> map = {};
    map["loginToken"] = token;
    return requestNetwork<LoginInfoData>(Method.post,
        params: map,
        url: HttpApi.keyLogin, isShow: true, onSuccess: (data) {
          if (data != null){
            if (data.code == 200) {

              SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
              SpUtil.putString(Constant.accessToken, data.data.token);

              view.loginSuccess();
            }
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

        if(data.data.token!=null&&data.data.token.isNotEmpty){
            SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
            SpUtil.putString(Constant.accessToken, data.data.token);
          view.hadBindWechat();
        }else{
          //没绑定
          view.wechatSuccess(data.data);

          // view.loginSuccess(myUserInfo);
        }


      }else{
        view.wechatFail();
      }

        },
        onError: (code, msg) {
          view.wechatFail();
        });
  }
}