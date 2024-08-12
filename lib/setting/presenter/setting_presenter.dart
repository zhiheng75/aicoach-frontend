import 'package:Bubble/entity/empty_response_entity.dart';
import 'package:Bubble/util/channel.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../login/entity/login_info_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../mvp/base_presenter.dart';
import '../../net/http_api.dart';
import '../../util/version_utils.dart';
import '../entity/updata_info_entity.dart';
import '../view/setting_view.dart';
import '../../net/dio_utils.dart';

class SettingPresenter extends BasePagePresenter<SettingView> {
  bool hasBindWX = false;
  bool hasBindPhone = false;
  bool hadNewVersion = false;
  String phoneNum = "";
  late LoginInfoDataData userInfo;

  String appVersion = "";
  int localAppCode = 0;
  int netAppCode = 0;

  @override
  void initState() {
    super.initState();

    VersionUtils.getAppVersion().then((value) {
      appVersion = value;
      localAppCode = int.parse(appVersion.replaceAll(".", ""));
      view.viewLocalAppName(appVersion);
    });

    SpUtil.getObj(
        Constant.userInfoKey,
        (v) => {
              if (v.isNotEmpty)
                {
                  userInfo = LoginInfoDataData.fromJson(v),
                  hasBindPhone = userInfo.phone.isNotEmpty,
                  phoneNum = userInfo.phone,
                  hasBindWX = userInfo.openid.isNotEmpty,
                  view.getUserInfo(userInfo),
                }
            });
  }

  @override
  void afterInit() {
    super.afterInit();
    getUpdate(false);
  }

  Future unbindWx() {
    // final Map<String, dynamic> params = <String, dynamic>{};
    // params['platform'] = "android";
    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.unbindWX, isShow: true, onSuccess: (data) {
      if (data != null) {
        if (data.code == 200) {
          userInfo.openid = "";
          SpUtil.putObject(Constant.userInfoKey, userInfo.toJson());
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
        isShow: true, onSuccess: (data) {
      if (data != null) {
        bindWx(data.data);
      } else {
        view.wechatFail("微信登录失败");
      }
    });
  }

  Future bindWx(LoginInfoDataData data) {
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
        url: HttpApi.bindWX, isShow: true, params: params, onSuccess: (mData) {
      userInfo.openid = data.openid;
      if (mData != null) {
        if (mData.code == 200) {
          SpUtil.putObject(Constant.userInfoKey, userInfo.toJson());
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

  Future getUpdate(show) {
    //platform  版本
    //android
    //ios
    final Map<String, dynamic> params = <String, dynamic>{};
    params['platform'] = Channel.channelios;
    return requestNetwork<UpdataInfoData>(Method.get,
        url: HttpApi.updateApp,
        queryParameters: params,
        isShow: show, onSuccess: (data) {
      if (data != null && data.code == 200) {
        if (data.data.version.isNotEmpty) {
          netAppCode = int.parse(data.data.version.replaceAll(".", ""));
          if (show) {
            if (netAppCode > localAppCode) {
              view.getAppInfo(data.data);
            } else {
              Toast.show("已是最新版本");
            }
          } else {
            if (netAppCode > localAppCode) {
              view.hasNewVersion(true);
            } else {
              view.hasNewVersion(false);
            }
          }
        }
      }
    });
  }
}
