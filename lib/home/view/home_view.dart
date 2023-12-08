import 'package:Bubble/mvp/mvps.dart';

import '../entity/teach_list_entity.dart';


abstract class HomeView implements IMvpView{
  // void setTeachList(List<SelectTeacherEntity> list);
  void setTeachList(List<TeachListEntity> list);


}