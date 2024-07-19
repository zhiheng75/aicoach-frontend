import 'package:oktoast/oktoast.dart';

/// Toast工具类
class Toast {
  static void show(String? msg, {int duration = 2000}) {
    if (msg == null) {
      return;
    }
    showToast(msg,
        position: ToastPosition.center,
        duration: Duration(milliseconds: duration),
        dismissOtherToast: true);
  }

  static void showBottom(String? msg, {int duration = 2000}) {
    if (msg == null) {
      return;
    }
    showToast(msg,
        position: ToastPosition.bottom,
        duration: Duration(milliseconds: duration),
        dismissOtherToast: true);
  }

  static void cancelToast() {
    dismissAllToast();
  }
}
