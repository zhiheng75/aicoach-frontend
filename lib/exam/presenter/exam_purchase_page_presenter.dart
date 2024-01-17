import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/exam/entity/goods_list_bean.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/log_utils.dart';

import '../../mvp/base_page_presenter.dart';
import '../view/exam_purchas_view.dart';

class ExamPurchasePagePresenter extends BasePagePresenter<ExamPurchaseView> {
  @override
  void afterInit() {
    super.afterInit();
    getGoodsList();
  }

  Future getGoodsList() {
    final Map<String, String> params = <String, String>{};
    params["type"] = "2";

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.goodsList,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Log.e(result.toString());

      Map<String, dynamic> goodsListMap = json.decode(result.toString());
      GoodsListBean goodsListBean = GoodsListBean.fromJson(goodsListMap);

      Log.e(goodsListBean.msg);
      if (goodsListBean != null) {
        view.sendSuccess(goodsListBean);
      } else {
        view.sendFail("");
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
