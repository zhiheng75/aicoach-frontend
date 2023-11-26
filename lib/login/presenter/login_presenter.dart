import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/wx_info_entity.dart';
import '../view/login_view.dart';


class LoginPresenter extends BasePagePresenter<LoginView>{

  Future login(String phoneNum, bool isShowLoading) {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['phone'] = phoneNum;

    return requestNetwork(Method.post,
        url: HttpApi.smsLogin,
        queryParameters: params,
        isShow: isShowLoading,
        onSuccess: (data) {});
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