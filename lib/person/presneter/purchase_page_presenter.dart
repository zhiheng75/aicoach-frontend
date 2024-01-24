import 'dart:convert';

import 'package:Bubble/home/entity/base_config_entity.dart';
import 'package:Bubble/person/entity/good_entity.dart';
import 'package:fluwx/fluwx.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:tobias/tobias.dart';

import '../../entity/result_entity.dart';
import '../../loginManager/login_manager.dart';
import '../../method/fluter_native.dart';
import '../../mvp/base_page_presenter.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/apple_pay_utils.dart';
import '../../util/device_utils.dart';
import '../../util/log_utils.dart';
import '../../util/toast_utils.dart';
import '../entity/ali_pay_entity.dart';
import '../entity/wx_pay_entity.dart';
import '../view/purchase_view.dart';

class PurchasePagePresenter extends BasePagePresenter<PurchaseView> {
  @override
  void afterInit() {
    // TODO: implement afterInit
    super.afterInit();
    // getBaseConfig();
  }

  Map<int, ProductDetails> productMapForGood = {};

  Future wxChatPay(goodId, goodPrice, bool showLoading) {
    final Map<String, dynamic> params = <String, String>{};
    params["goods_id"] = goodId.toString();
    params["goods_price"] = goodPrice.toString();
    params["payment_method"] = "WXPAY"; //0=WXPAY 1=ALIPAY
    return requestNetwork<WxPayData>(Method.post,
        url: HttpApi.wxOrder,
        isShow: showLoading,
        params: params, onSuccess: (data) async {
      if (data != null) {
        WxPayDataData payData = data.data;
        if (Device.isAndroid) {
          FlutterToNative.jumpToWechatPay(json.encode(payData)).then((value) {
            if (value == 0) {
              Toast.show("支付成功");
              getOrderStatus(payData.order_no, "WXPAY");
            } else {
              Toast.show("支付失败");
            }
          });
        }
        if (Device.isIOS) {
          Fluwx fluwx = Fluwx();
          bool isRegistered = await fluwx.registerApi(
            appId: payData.appid,
            doOnAndroid: false,
            doOnIOS: true,
            universalLink: 'https://demo.shenmo-ai.net/ios/',
          );
          if (!isRegistered) {
            Toast.show('支付失败');
            return;
          }
          bool isInstalledWx = await fluwx.isWeChatInstalled;
          if (!isInstalledWx) {
            Toast.show('请先安装微信');
            return;
          }
          // 设置监听
          fluwx.addSubscriber((response) {
            fluwx.clearSubscribers();
            if (response.errCode == 0) {
              Toast.show("支付成功");
              getOrderStatus(payData.order_no, "WXPAY");
            } else if (response.errCode == -2) {
              Toast.show('取消支付');
            } else {
              Toast.show('支付失败:${response.errStr}');
            }
          });
          fluwx.pay(
            which: Payment(
              appId: payData.appid,
              partnerId: payData.partnerid,
              packageValue: payData.package,
              prepayId: payData.prepayId,
              nonceStr: payData.noncestr,
              timestamp: int.parse(payData.timestamp),
              sign: payData.sign,
            ),
          );
        }
      }
    });
  }

  Future aliPay(goodId, goodPrice, bool showLoading) {
    final Map<String, dynamic> params = <String, String>{};
    params["goods_id"] = goodId.toString();
    params["goods_price"] = goodPrice.toString();
    params["payment_method"] = "ALIPAY"; //0=WXPAY 1=ALIPAY

    return requestNetwork<AliPayData>(Method.post,
        url: HttpApi.wxOrder,
        isShow: showLoading,
        params: params, onSuccess: (data) async {
      if (data != null) {
        AliPayDataData payData = data.data;
        if (Device.isAndroid) {
          FlutterToNative.jumpToALiPay(json.encode(payData)).then((value) {
            if (value == 0) {
              Toast.show("支付成功");
              getOrderStatus(payData.orderNo, "ALIPAY");
            } else {
              Toast.show("支付失败");
            }
          });
        }
        if (Device.isIOS) {
          Tobias tobias = Tobias();
          bool isInstalledAlipay = await tobias.isAliPayInstalled;
          if (!isInstalledAlipay) {
            Toast.show('请先安装支付宝');
            return;
          }
          tobias.pay(payData.prepayUrl).then(
            (result) {
              Log.d('支付结果:$result');
              String code = result['resultStatus'];
              if (code == '9000') {
                Toast.show("支付成功");
                getOrderStatus(payData.orderNo, "ALIPAY");
              } else if (code == '6001') {
                Toast.show("取消支付");
              } else if (code == '8000') {
                Toast.show("支付处理中，请在购买记录页确认是否开通成功");
              } else if (code == '6004') {
                Toast.show("支付处理中，请在购买记录页确认是否开通成功");
              } else {
                Toast.show(result['memo']);
              }
            },
            onError: (_) {
              Toast.show('支付失败');
              Log.d('iOS支付宝支付异常:error:$_');
            },
          );
        }
      }
    });
  }

  Future applePay(goodId) async {
    ProductDetails? product = productMapForGood[goodId];
    if (product == null) {
      Toast.show(
        '未设置商品',
        duration: 1000,
      );
      return;
    }
    getView().showProgress();
    // 购买（用户ID进行区分）
    int userId = LoginManager.getUserId();
    ApplePayUtils.pay(
      product: product,
      userId: userId.toString(),
      onSuccess: () {
        getView().closeProgress();
        Toast.show(
          '开通成功',
          duration: 1000,
        );
        view.paySuccess();
      },
      onFail: () {
        getView().closeProgress();
        Toast.show(
          '支付异常',
          duration: 1000,
        );
      },
      onCancel: () {
        getView().closeProgress();
        Toast.show(
          '取消支付',
          duration: 1000,
        );
      },
    );
  }

  Future getOrderStatus(goodId, paymentMethod) {
    Map<String, dynamic> map = {};
    map["order_no"] = goodId;
    map["payment_method"] = paymentMethod;

    return requestNetwork<ResultData>(Method.get,
        url: HttpApi.queryOrderStatus,
        queryParameters: map,
        isShow: true, onSuccess: (result) {
      try {
        if (result != null && result.code == 200 && result.data != null) {
          Map<String, dynamic> data = result.data! as Map<String, dynamic>;
          if (data['status'] != 'Failed') {
            Toast.show('开通成功');
            view.paySuccess();
            return;
          }
          throw Exception('查询订单失败，请在购买记录页查看');
        }
        throw Exception('查询订单失败，请在购买记录页查看');
      } catch (e) {
        Toast.show(e.toString());
      }
    }, onError: (code, msg) {
      Toast.show(msg);
    });
  }

  // 获取iOS商品列表
  Future<void> getIosProduct(List<GoodEntity> goodList) async {
    Map<String, dynamic> idMap = {};
    for (GoodEntity good in goodList) {
      idMap[good.productId] = good.id;
    }

    List<String> ids = idMap.keys.toList();
    List<ProductDetails> productList = await ApplePayUtils.getProductList(ids);
    for (var product in productList) {
      productMapForGood[idMap[product.id]] = product;
    }
  }
}
