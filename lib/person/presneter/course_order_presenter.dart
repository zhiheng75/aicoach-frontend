import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/order_list_bean.dart';
import 'package:Bubble/person/view/course_order_view.dart';

class CourseOrderPresenter extends BasePagePresenter<CourseOrderView> {
  @override
  void afterInit() {
    super.afterInit();
    getOrderlist();
  }

  Future getOrderlist() async {
    final Map<String, dynamic> params = <String, dynamic>{};
    params['type'] = "4";
    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.orderList,
        queryParameters: params,
        isShow: false, onSuccess: (result) {
      Map<String, dynamic> orderListBeanMap = json.decode(result.toString());
      OrderListBean orderListBean = OrderListBean.fromJson(orderListBeanMap);
      if (orderListBean.code == 200) {
        view.sendSuccess(orderListBean);
      } else {
        view.sendFail(orderListBean.msg);
      }
    });
  }
}
