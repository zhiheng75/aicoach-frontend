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
        isShow: isShowLoading, onSuccess: (data) {

        });
  }

}