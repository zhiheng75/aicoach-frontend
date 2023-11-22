import 'package:flutter/cupertino.dart';

class HomeTeacherProvider extends ChangeNotifier{

  int _selectIndex = 0;
  int get index => _selectIndex;

  void refresh() {
    notifyListeners();
  }

  void setSelectIndex(int index) {
    _selectIndex = index;
    notifyListeners();
  }
}