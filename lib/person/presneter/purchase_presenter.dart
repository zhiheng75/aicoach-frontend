import 'package:Bubble/mvp/base_page_presenter.dart';
import 'package:Bubble/person/presneter/purchase_view.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../entity/good_list_entity.dart';
import '../entity/my_good_list_entity.dart';
import '../entity/wx_pay_entity.dart';

class PurchasePresenter extends BasePagePresenter<PurchaseView>{

   List<MyGoodListEntity> goodList = [];



  Future wxChatPay(goodId,goodPrice,bool showLoading){
    final Map<String, dynamic> params = <String, String>{};
    params["goods_id"] = goodId.toString();
    // params["goods_price"] = goodPrice.toString();
    params["goods_price"] = "0.01";
    params["payment_method"] = "WXPAY";

    return requestNetwork<WxPayData>(
        Method.post,
        url: HttpApi.wxOrder,
        isShow: showLoading,
        params: params,
        onSuccess: (data){
          if(data!=null&&data.data!=null){
            view.getWXPayMsg(data.data);
          }
        }
    );
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