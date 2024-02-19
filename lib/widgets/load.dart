import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../res/gaps.dart';

/// 自定义一个弹窗，不用dialog的
class LoadingDialog {
  static late BuildContext _context;

  static void show(BuildContext context) {
    _context = context;
    Navigator.push(_context, DialogRouter(_LoadingDialog()));
  }

  static void hidden() {
    if (Navigator.canPop(_context)) {
      Navigator.pop(_context);
    }
  }
}

class DialogRouter extends PageRouteBuilder {
  final Widget page;

  DialogRouter(this.page)
      : super(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) => page,
        );
}

class _LoadingDialog extends Dialog {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        ///背景透明
        color: Colors.black54,

        ///保证控件居中效果
        child: Center(
          ///弹框大小
          child: Container(
            ///弹框背景和圆角
            height: 88.0,
            width: 120.0,
            decoration: const ShapeDecoration(
              color: Color(0xFF3A3A3A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // CircularProgressIndicator(),
                Theme(
                  data: ThemeData(
                    cupertinoOverrideTheme: const CupertinoThemeData(
                      brightness: Brightness.dark, // 局部指定夜间模式，加载圈颜色会设置为白色
                    ),
                  ),
                  child: const CupertinoActivityIndicator(radius: 14.0),
                ),

                Gaps.vGap8,
                const Text(
                  "正在加载...",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
