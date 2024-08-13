import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/bind_teacher_bean.dart';
import 'package:Bubble/person/entity/get_pay_code_bean.dart';
import 'package:Bubble/person/entity/query_order_bean.dart';
import 'package:Bubble/person/view/xueersi_purchase_page_view.dart';

class XueersiPurchasePagePresenter
    extends BasePagePresenter<XueersiPurchasePageView> {
  Future getPayCode(String goodId) {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.payCode,
        queryParameters: {
          'good_id': goodId,
        },
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> getPayCodeBeanMap = json.decode(result.toString());
      GetPayCodeBean getPayCodeBean =
          GetPayCodeBean.fromJson(getPayCodeBeanMap);

      if (getPayCodeBean.code == 200) {
        view.sendSuccess(getPayCodeBean);
      } else {
        view.sendFail(getPayCodeBean.msg);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }

  Future getQueryOrder(String orderNo) {
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.payCode,
        queryParameters: {
          'order_no': orderNo,
          'payment_method': "WXJSPAY",
        },
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> queryOrderBeanMap = json.decode(result.toString());
      QueryOrderBean queryOrderBean =
          QueryOrderBean.fromJson(queryOrderBeanMap);
      if (queryOrderBean.code == 200) {
        view.sendQueryOrderSuccess(queryOrderBean.data.status);
      }
    }, onError: (code, msg) {
      view.sendFail("");
    });
  }
}
