import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
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


  // Future wechatInfo()

  Future wechatLogin(
    String wechatCode,
  ) {
    final Map<String, String> params = <String, String>{};
    params["code"] = wechatCode;
    params["platform"] = "app";

    return requestNetwork(Method.get,
        url: HttpApi.wechatLogin,
        queryParameters: params,
        isShow: true,
        onSuccess: (data) {
          //view.wechatSuccess(data)
        },
        onError: (code, msg) {
          view.wechatFail();
        });
  }
}