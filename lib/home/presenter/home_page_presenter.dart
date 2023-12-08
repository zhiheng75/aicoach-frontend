import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/util/toast_utils.dart';

import '../../mvp/base_page_presenter.dart';
import '../../net/http_api.dart';
import '../entity/teach_list_entity.dart';
import '../view/home_view.dart';

class HomePagePresenter extends BasePagePresenter<HomeView>{
  Future getTeacherList(bool showLoading){
    return requestNetwork<List<TeachListEntity>>(
      Method.get,
      url: HttpApi.teacherList,
      isShow: showLoading,
      isClose: showLoading,
      onSuccess: (data){
        if(data !=null && data.isNotEmpty) {
          view.setTeachList(data);
        }else{
          Toast.show("获取老师数据失败");
        }
      }
    );
  }
}