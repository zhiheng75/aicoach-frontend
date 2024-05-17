import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/goods_bean.dart';
import 'package:Bubble/person/view/user_membership_upgrade_page_view.dart';

class UserMembershipUpgradepagePresenter
    extends BasePagePresenter<UserMembershipUpgradePageView> {
  get result => null;

  @override
  void afterInit() {
    super.afterInit();
    getStudyInfo();
  }

  Future getStudyInfo() async {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.goods,
        isShow: false,
        queryParameters: {
          'type': 4,
        }, onSuccess: (data) {
      Map<String, dynamic> goodsBeanMap = json.decode(data.toString());
      GoodsBean goodsBean = GoodsBean.fromJson(goodsBeanMap);
      if (goodsBean.code == 200) {
        view.sendSuccess(goodsBean);
      } else {
        view.sendFail(goodsBean.msg);
      }
    });
  }
}
