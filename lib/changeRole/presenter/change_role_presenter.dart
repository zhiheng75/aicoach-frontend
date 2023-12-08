import 'package:Bubble/mvp/base_page_presenter.dart';

import '../../home/entity/teach_list_entity.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../util/toast_utils.dart';
import '../view/change_role_view.dart';

class ChangeRolePresenter extends BasePagePresenter<ChangeRoleView>{
  List<TeachListEntity> allTeacher = [];

  @override
  void initState() {
    super.initState();
    getTeacherList(false);
  }
  Future getTeacherList(bool showLoading){
    return requestNetwork<List<TeachListEntity>>(
        Method.get,
        url: HttpApi.teacherList,
        isShow: showLoading,
        onSuccess: (data){
          if(data!=null&&data.isNotEmpty) {

            // for(int i = 0;i<data.length;i++){
            //   data[i].index = i;
            //   data[i].isSelect = i==0;
            // }
            allTeacher.clear();
            allTeacher.addAll(data);
            view.setTeachList(data);
          }else{
            Toast.show("获取老师数据失败");
          }
        }
    );
  }
}