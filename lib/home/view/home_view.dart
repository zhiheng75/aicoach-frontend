import 'package:spokid/mvp/mvps.dart';

import '../model/select_teacher_entity.dart';

abstract class HomeView implements IMvpView{
  void setTeachList(List<SelectTeacherEntity> list);
}