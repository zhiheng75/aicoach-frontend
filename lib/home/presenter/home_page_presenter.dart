import 'package:Bubble/mvp/base_presenter.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/util/toast_utils.dart';

import '../../mvp/base_page_presenter.dart';
import '../../net/http_api.dart';
import '../entity/select_teacher_entity.dart';
import '../entity/teach_list_entity.dart';
import '../view/home_view.dart';

class HomePagePresenter extends BasePagePresenter<HomeView>{

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

          for(int i = 0;i<data.length;i++){
            data[i].index = i;
            data[i].isSelect = i==0;
          }

          view.setTeachList(data);
        }else{
          Toast.show("获取老师数据失败");
        }
      }
    );
  }

  //网络请求
  Future<void> requestNetwork2(){
    return Future.delayed(const Duration(seconds: 1), (){
      // view.setTeachList(_initTeacherData());
    });
  }


  List<SelectTeacherEntity> _initTeacherData(){
    List<SelectTeacherEntity> allTeacher = [];
    for (int i = 0; i < 10; i++) {
      SelectTeacherEntity t1 = SelectTeacherEntity();
      t1.teacherName = "lity老师$i";
      t1.index = i;
      t1.teacherHeader = "test_banner_img";
      t1.isSelect = i == 0 ? true : false;
      t1.school = "加州大学任教";
      t1.category="温和  热情";
      allTeacher.add(t1);
    }
    return allTeacher;
  }
}