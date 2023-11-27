import '../../mvp/base_page_presenter.dart';
import '../../mvp/base_presenter.dart';
import '../../net/http_api.dart';
import '../view/setting_view.dart';
import '../../net/dio_utils.dart';

class SettingPresenter extends BasePagePresenter<SettingView>{



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