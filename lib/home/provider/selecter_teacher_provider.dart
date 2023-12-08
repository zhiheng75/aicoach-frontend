import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:flustars_flutter3/flustars_flutter3.dart';
import 'package:flutter/cupertino.dart';

import '../../constant/constant.dart';
import '../entity/teach_list_entity.dart';

class HomeTeacherProvider extends ChangeNotifier{

  // 当前可对话的老师
  TeachListEntity? _teacher;
  // 选择老师选中的老师
  TeachListEntity? _selectedTeacher;

  TeachListEntity? get teacher => _teacher;
  TeachListEntity? get selectedTeacher => _selectedTeacher;

  Future<String?> getUserId() async {
    String? id;
    if (LoginManager.isLogin()) {
      Map<dynamic, dynamic>? value = SpUtil.getObject(Constant.userInfoKey);
      if (value != null) {
        int id = value['id'] ?? 0;
        if (id != 0) {
          id = id;
        }
      }
    } else {
      id = await Device.getDeviceId();
    }
    return id;
  }

  void getCachedTeacherForUser() async {
    String? id = await getUserId();
    if (id == null) {
      return;
    }
    Map<dynamic, dynamic>? teacher = SpUtil.getObject('${Constant.teacher}_$id');
    if (teacher == null) {
      return;
    }
    _teacher = TeachListEntity.fromJson(teacher as Map<String, dynamic>);
    notifyListeners();
  }

  void chooseTeacher(TeachListEntity? teacher) {
    _selectedTeacher = teacher;
    notifyListeners();
  }

  void updateTeacher() async {
    String? id = await getUserId();
    if (id != null) {
      SpUtil.putObject('${Constant.teacher}_$id', _selectedTeacher!.toJson());
    }
    _teacher = _selectedTeacher;
    _selectedTeacher = null;
    notifyListeners();
  }
}