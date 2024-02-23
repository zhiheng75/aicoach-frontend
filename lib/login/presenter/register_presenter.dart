import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/login/entity/new_wx_entity.dart';
import 'package:Bubble/login/entity/user_info_entity.dart';
import 'package:Bubble/util/EventBus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../entity/empty_response_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/login_info_entity.dart';
import '../entity/my_user_info_entity.dart';
import '../view/register_view.dart';

class RegisterPresenter extends BasePagePresenter<RegisterView> {
  static late CancelToken cancelToken;
  Future sendSms(String phoneNum, bool isShowLoading) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['phone'] = phoneNum;
    cancelToken = CancelToken();

    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.smsLogin,
        queryParameters: params,
        cancelToken: cancelToken,
        isShow: isShowLoading, onSuccess: (data) {
      if (data != null && data.code == 200) {
        Toast.show("短信发送成功，请注意查收");
      } else {
        Toast.show("发送失败");
      }
    });
  }

  static void disHttpKeySendSms() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel();
    }
  }

  Future toBind(String phoneNum, String smsCode, NewWxInfoBeanData data) {
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
        isShow: true, onSuccess: (data) {
      EventBus().emit('ERROR');
      if (data != null) {
        if (data.code == 200) {
          SpUtil.putObject(Constant.userInfoKey, data.data.toJson());
          SpUtil.putString(Constant.accessToken, data.data.token);
          // view.wechatLoginSuccess("登录成功");
          view.loginSuccess();
        } else {
          // view.wechatLoginFail(data.msg);
        }
      }
    });
  }

  Future register(String phoneNum, String code, bool isShowLoading) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['phone'] = phoneNum;
    params['code'] = code;

    return requestNetwork<LoginInfoData>(Method.post,
        url: HttpApi.phoneLogin,
        queryParameters: params,
        isShow: isShowLoading, onSuccess: (data) {
      EventBus().emit('ERROR');
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
      } else {
        Toast.show("登录失败");
      }
    });
  }

  Future sendKeyLoginToken(token) {
    Map<String, String> map = {};
    map["loginToken"] = token;
    return requestNetwork<LoginInfoData>(Method.post,
        params: map, url: HttpApi.keyLogin, isShow: true, onSuccess: (data) {
      if (data != null) {
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

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.wechatInfo,
        queryParameters: params,
        isShow: true, onSuccess: (result) {
      Log.e("微信登陆成功回调=============");

      Log.e(result.toString());

      // Map<String, dynamic> data = result?.data! as Map<String, dynamic>;

      Map<String, dynamic> newWxInfoMap = json.decode(result.toString());
      NewWxInfoBean newWxInfoBean = NewWxInfoBean.fromJson(newWxInfoMap);
      // Log.e("=============");
      // Log.e(newWxInfoBean.data.openid);
      // Log.e("=============");

      // Map<String, dynamic> data = result?.data! as Map<String, dynamic>;

      // // Map loginMap = json.decode(result.toString());
      // NewWxInfoBeanData loginModel = NewWxInfoBeanData.fromJson(data);
      // Log.e("=============");

      // Log.e(loginModel.openid);
      // Log.e("=============");

      // ignore: unnecessary_null_comparison
      if (newWxInfoBean != null) {
        Log.e("======进来了吗=======");
        if (validateInput(newWxInfoBean.data.token)) {
          SpUtil.putObject(Constant.userInfoKey, newWxInfoBean.data.toJson());
          SpUtil.putString(Constant.accessToken, newWxInfoBean.data.token);
          Log.e("======进来了吗=======");
          view.hadBindWechat();
        } else {
          //没绑定
          view.newwechatSuccess(newWxInfoBean.data);

          // view.loginSuccess(myUserInfo);
        }
      } else {
        view.wechatFail();
      }
    }, onError: (code, msg) {
      view.wechatFail();
    });
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input == "null") {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }
}
