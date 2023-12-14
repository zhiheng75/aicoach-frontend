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

  Future<String> getUserId() async {
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
    return id ?? '';
  }

  void chooseTeacher(TeachListEntity? teacher) {
    _selectedTeacher = teacher;
    notifyListeners();
  }

  void updateTeacher([TeachListEntity? teacher]) async {
    teacher = teacher ?? _selectedTeacher;
    String userId = await getUserId();
    if (userId != '') {
      SpUtil.putObject('${Constant.teacher}_$userId', teacher!.toJson());
    }
    _teacher = teacher;
    if (_selectedTeacher != null) {
      _selectedTeacher = null;
    }
    notifyListeners();
  }
}