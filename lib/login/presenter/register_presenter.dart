import 'package:Bubble/util/toast_utils.dart';

import '../../entity/empty_response_entity.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/wx_info_entity.dart';
import '../view/login_view.dart';
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

    return requestNetwork<EmptyResponseData>(Method.post,
        url: HttpApi.smsLogin,
        queryParameters: params,
        isShow: isShowLoading, onSuccess: (data) {
      if (data != null) {
        if (data.code == 200) {
          Toast.show("登录成功");
          view.loginSuccess();
        } else {
          Toast.show(data.msg);
        }
      }else{
        Toast.show("登录失败");
      }
    });
  }



  Future getWxInfo(
    String wechatCode,
  ) {
    final Map<String, String> params = <String, String>{};
    params["code"] = wechatCode;
    params["platform"] = "app";

    return requestNetwork<WxInfoData>(Method.get,
        url: HttpApi.wechatInfo,
        queryParameters: params,
        isShow: true,
        onSuccess: (data) {
      if(data!=null){

        if(data.data.token!=null&&data.data.token.isNotEmpty){
          view.hadBindWechat(data.data);
        }else{
          view.wechatSuccess(data.data);
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