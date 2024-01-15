import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//取消按钮的index 为 0 ,确认为 1
typedef ClickCallBack = void Function(int selectIndex, String selectText);

// ignore: camel_case_types
class myAlert {
  static void showAlert(BuildContext context,
      {required String title,
      required String content,
      String leftText = "取消",
      String rightText = "确认",
      required ClickCallBack clickCallback}) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Offstage(
              // ignore: unnecessary_null_comparison
              offstage: title == null ? true : false,
              // ignore: unnecessary_null_comparison
              child: Text(title),
            ),
            content: Offstage(
              // ignore: unnecessary_null_comparison
              offstage: content == null ? true : false,
              child: Text(content),
            ),
            actions: <Widget>[
              TextButton(
                //取消
                child: Text(
                  leftText,
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  clickCallback(0, leftText);
                },
              ),
              TextButton(
                //确认
                child: Text(
                  rightText,
                  style: const TextStyle(color: Colors.blueAccent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  clickCallback(1, leftText);
                },
              ),
            ],
          );
        });
  }

  /**
      index 从上往下 1，2，3，取消是0
   */
  static void showActionSheet(BuildContext context,
      {required String title,
      required String content,
      required List<String> otherBtnTitles,
      required String redBtnTitle,
      required ClickCallBack clickCallback}) {
    List<CupertinoActionSheetAction> otherBtns = [];
    for (int i = 1; i < otherBtnTitles.length + 1; i++) {
      var w = CupertinoActionSheetAction(
        onPressed: () {
          Navigator.pop(context);
          clickCallback(i, otherBtnTitles[i - 1]);
        },
        child: Text(otherBtnTitles[i - 1]),
      );
      otherBtns.add(w);
    }

    var w = CupertinoActionSheetAction(
      onPressed: () {
        Navigator.pop(context);
        clickCallback(otherBtnTitles.length + 1, redBtnTitle);
      },
      isDestructiveAction: true,
      child: Text(redBtnTitle),
    );
    otherBtns.insert(otherBtnTitles.length, w);

    // ignore: unnecessary_null_comparison
    if (title == null) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: otherBtns,
            cancelButton: CupertinoActionSheetAction(
              //取消按钮
              onPressed: () {
                Navigator.pop(context);
                clickCallback(0, "取消");
              },
              child: const Text('取消'),
            ),
          );
        },
      );
    } else {
      // ignore: unnecessary_null_comparison
      if (content != null) {
        showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: Offstage(
                // ignore: unnecessary_null_comparison
                offstage: title == null ? true : false,
                child: Text(title, style: const TextStyle(fontSize: 20)),
              ),
              message: Text(content),
              actions: otherBtns,
              cancelButton: CupertinoActionSheetAction(
                //取消按钮
                onPressed: () {
                  Navigator.pop(context);
                  clickCallback(0, "取消");
                },
                child: const Text('取消'),
              ),
            );
          },
        );
      } else {
        showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoActionSheet(
              title: Offstage(
                // ignore: unnecessary_null_comparison
                offstage: title == null ? true : false,
                child: Text(title),
              ),
              actions: otherBtns,
              cancelButton: CupertinoActionSheetAction(
                //取消按钮
                onPressed: () {
                  Navigator.pop(context);
                  clickCallback(0, "取消");
                },
                child: const Text('取消'),
              ),
            );
          },
        );
      }
    }
  }
}
