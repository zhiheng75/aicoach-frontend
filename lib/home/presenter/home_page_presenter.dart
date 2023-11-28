import 'package:Bubble/mvp/base_presenter.dart';

import '../model/select_teacher_entity.dart';
import '../view/home_view.dart';

class HomePagePresenter extends BasePresenter<HomeView>{

  @override
  void initState() {
    super.initState();
    requestNetwork();

  }



  // 网络请求
  Future<void> requestNetwork(){
    return Future.delayed(const Duration(seconds: 1), (){
      view.setTeachList(_initTeacherData());
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