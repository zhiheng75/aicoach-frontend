import 'package:Bubble/mvp/mvps.dart';

import '../../home/entity/teach_list_entity.dart';

abstract class ChangeRoleView implements IMvpView{
  void setTeachList(List<TeachListEntity> list);
}