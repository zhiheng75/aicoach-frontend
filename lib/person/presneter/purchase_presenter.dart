import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/person/presneter/purchase_view.dart';
import 'package:Bubble/util/apple_pay_utils.dart';
import 'package:sp_util/sp_util.dart';

import '../../constant/constant.dart';
import '../../home/entity/base_config_entity.dart';
import '../../method/fluter_native.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
import '../entity/ali_pay_entity.dart';
import '../entity/good_list_entity.dart';
import '../entity/my_good_list_entity.dart';
import '../entity/wx_pay_entity.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchasePresenter extends BasePagePresenter<PurchaseView>{

   List<MyGoodListEntity> goodList = [];
   Map<int, ProductDetails> productMapForGood = {};


  @override
  void initState() {
    super.initState();
    SpUtil.getObjList(
        Constant.baseConfig,
        (v) => {
              if (v.isNotEmpty)
                {
                  view.getBaseConfig(BaseConfigDataData.fromJson(v as Map<String, dynamic>)),
                }
            });
  }

  @override
  void afterInit() {
    super.afterInit();
    getGoodsList(true);
  }

  Future wxChatPay(goodId,goodPrice,bool showLoading){
    final Map<String, dynamic> params = <String, String>{};
    params["goods_id"] = goodId.toString();
    params["goods_price"] = goodPrice.toString();
    params["payment_method"] = "WXPAY";//0=WXPAY 1=ALIPAY
    return requestNetwork<WxPayData>(
        Method.post,
        url: HttpApi.wxOrder,
        isShow: showLoading,
        params: params,
        onSuccess: (data){
          if(data!=null){
            FlutterToNative.jumpToWechatPay(json.encode(data.data)).then((value){
              if(value==0){
                Toast.show("支付成功");
                getOrderStatus(data.data.order_no,"WXPAY");
                view.paySuccess();
              }else {
                Toast.show("支付失败");
              }
            });

            // view.getWXPayMsg(data.data);
          }
        }
    );
  }


  Future aliPay(goodId,goodPrice,bool showLoading){
   final Map<String, dynamic> params = <String, String>{};
   params["goods_id"] = goodId.toString();
   params["goods_price"] = goodPrice.toString();
   params["payment_method"] = "ALIPAY";//0=WXPAY 1=ALIPAY

   return requestNetwork<AliPayData>(
       Method.post,
       url: HttpApi.wxOrder,
       isShow: showLoading,
       params: params,
       onSuccess: (data){
         if(data!=null){

           FlutterToNative.jumpToALiPay(json.encode(data.data)).then((value){
             if(value==0){
               Toast.show("支付成功");
               getOrderStatus(data.data.orderNo,"ALIPAY");
               view.paySuccess();
             }else {
               Toast.show("支付失败");
             }
           });
         }
       }
   );
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

  Future getOrderStatus(goodId,paymentMethod){

   Map<String,dynamic> map = {};
   map["order_no"] = goodId;
   map["payment_method"] = paymentMethod;

   return requestNetwork(Method.get,
       url: HttpApi.queryOrderStatus,
       queryParameters: map,
       isShow: false,
       onSuccess: (data) {

       });
  }

  Future getGoodsList(bool showLoading){
    return requestNetwork<GoodListData>(
        Method.get,
        url: HttpApi.goodList,
        isShow: showLoading,
        onSuccess: (data) async {
          if(data!=null&&data.data.isNotEmpty){
            if (Platform.isIOS) {
              await getIosProduct(data.data);
            }
            goodList.clear();
            for(int i = 0;i<data.data.length;i++){
              MyGoodListEntity entity = MyGoodListEntity();
              entity.name = data.data[i].name;
              entity.desc = data.data[i].desc;
              entity.status = data.data[i].status;
              entity.sort = data.data[i].sort;
              entity.updatedAt = data.data[i].updatedAt;
              entity.price = data.data[i].price;
              entity.id = data.data[i].id;
              entity.unit = data.data[i].unit;
              entity.createdAt = data.data[i].createdAt;
              entity.isSelect = i==0;
              entity.recommend = i ==0;
              goodList.add(entity);
            }
            view.goodListData(goodList);
          }

        }
    );
  }

  // 获取iOS商品列表
  Future<void> getIosProduct(List<GoodListDataData> goodList) async {
    Map<String, dynamic> idMap = {};
    for (GoodListDataData good in goodList) {
      idMap[good.productId] = good.id;
    }

    List<String> ids = idMap.keys.toList();
    List<ProductDetails> productList = await ApplePayUtils.getProductList(ids);
    for (var product in productList) {
      productMapForGood[idMap[product.id]] = product;
    }
  }

}