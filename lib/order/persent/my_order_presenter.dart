
import 'package:Bubble/mvp/base_page_presenter.dart';

import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../view/my_order_view.dart';

class MyOrderPresenter extends BasePagePresenter<MyOrderView>{

  List<String> mList = [];

  @override
  void initState() {
    super.initState();
    getOrderList(false);
  }

  Future getOrderList(bool showLoading){
    return requestNetwork(
        Method.get,
        url: HttpApi.orderRecords,
        isShow: showLoading,
        onSuccess: (data){
          // if(data!=null&&data.data!=null&&data.data.isNotEmpty){
          //   goodList.clear();
          //   for(int i = 0;i<data.data.length;i++){
          //     MyGoodListEntity entity = MyGoodListEntity();
          //     entity.name = data.data[i].name;
          //     entity.desc = data.data[i].desc;
          //     entity.status = data.data[i].status;
          //     entity.sort = data.data[i].sort;
          //     entity.updatedAt = data.data[i].updatedAt;
          //     entity.price = data.data[i].price;
          //     entity.id = data.data[i].id;
          //     entity.unit = data.data[i].unit;
          //     entity.createdAt = data.data[i].createdAt;
          //     entity.isSelect = i==0;
          //     entity.recommend = i ==0;
          //     goodList.add(entity);
          //   }
          //   view.goodListData(goodList);
          // }

        }
    );
  }
}