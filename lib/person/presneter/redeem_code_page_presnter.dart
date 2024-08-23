import 'dart:convert';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/person/entity/redeem_code_bean.dart';
import 'package:Bubble/person/entity/redeem_list_bean.dart';
import 'package:Bubble/person/view/redeem_code_view.dart';
import 'package:Bubble/util/toast_utils.dart';

class RedeemCodePagePresenter extends BasePagePresenter<RedeemCodeView> {
  @override
  void afterInit() {
    super.afterInit();
    getRedeemList();
  }

  Future getRedeemList() async {
    return requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.redeemList,
      isShow: false,
      isClose: false,
      onSuccess: (data) {
        Map<String, dynamic> redeemListBeanMap = json.decode(data.toString());
        RedeemListBean redeemListBean =
            RedeemListBean.fromJson(redeemListBeanMap);

        if (redeemListBean.code == 200) {
          view.sendSuccess(redeemListBean);
        } else {
          view.sendFail(redeemListBean.msg);
        }
      },
      onError: (code, msg) {
        view.sendTwoFail(msg);
      },
    );
  }

  Future postRedeemCode(String code) async {
    return requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.redeemCode,
      queryParameters: {
        'code': code,
      },
      isShow: false,
      isClose: false,
      onSuccess: (data) {
        Map<String, dynamic> resultDataMap = json.decode(data.toString());
        RedeemCodeBean resultData = RedeemCodeBean.fromJson(resultDataMap);
        if (resultData.code == 200) {
          view.sendCodeSuccess(resultData.data);
        } else if (resultData.code == 502) {
          Toast.show("服务器暂时无法处理您的请求，请稍后再试");
        } else {
          view.sendCodeFail(resultData.msg);
        }
        // view.sendCodeSuccess(resultData);
      },
      onError: (code, msg) {
        if (code == 502) {
          Toast.show("服务器暂时无法处理您的请求，请稍后再试");
        } else {
          Toast.show("网络连接异常，请稍后重试");
        }

        // view.sendFail(msg);
      },
    );
  }
}
