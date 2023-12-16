import 'package:Bubble/constant/constant.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';

import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/base_config_entity.dart';
import '../view/home_view.dart';

class HomePagePresenter extends BasePagePresenter<HomeView>{

  @override
  void initState() {
    super.initState();
    getBaseConfig();
  }


  Future getBaseConfig(){
    return requestNetwork<BaseConfigData>(Method.get,
        url: HttpApi.baseConfig, isShow: false, onSuccess: (data) {
      if (data != null &&
          data.code == 200 &&
          data.data != null &&
          data.data.isNotEmpty) {
        SpUtil.putObjectList(Constant.baseConfig, data.data);
      }
    });
  }
}