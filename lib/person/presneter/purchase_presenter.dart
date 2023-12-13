import 'dart:convert';

import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/person/presneter/purchase_view.dart';

import '../../method/fluter_native.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
import '../entity/ali_pay_entity.dart';
import '../entity/good_list_entity.dart';
import '../entity/my_good_list_entity.dart';
import '../entity/wx_pay_entity.dart';

class PurchasePresenter extends BasePagePresenter<PurchaseView>{

   List<MyGoodListEntity> goodList = [];



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
          if(data!=null&&data.data!=null){
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
           if(data!=null&&data.data!=null){

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
        onSuccess: (data){
          if(data!=null&&data.data!=null&&data.data.isNotEmpty){
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

}