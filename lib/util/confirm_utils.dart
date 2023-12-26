import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmUtils {

  static void show({
    required BuildContext context,
    required String title,
    required Function() onConfirm,
    Widget? child,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => Confirm(
        title: title,
        onConfirm: onConfirm,
        child: child,
      ),
    );
  }

}

class Confirm extends StatelessWidget {
  const Confirm({
    Key? key,
    required this.title,
    required this.onConfirm,
    this.child,
  }) : super(key: key);

  final String title;
  final Function() onConfirm;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();
    Color borderColor = const Color(0xFF3C3C43).withOpacity(0.36);

    Widget button(String text, {
      required Function() onPress,
    }) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onPress,
          child: Container(
            height: 44.0,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 1.0,
                  style: BorderStyle.solid,
                  color: borderColor,
                ),
              ),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Color(0xFF007AFF),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: screenUtil.screenWidth,
      color: Colors.black.withOpacity(0.4),
      alignment: Alignment.center,
      child: Container(
        width: 270.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: const Color(0xFFB3B3B3)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(
              height: 19.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 22.0 / 17.0,
                ),
              ),
            ),
            if (child != null)
              Padding(
                padding: const EdgeInsets.only(
                  top: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: child!,
              ),
            const SizedBox(
              height: 17.0,
            ),
            Row(
              children: <Widget>[
                button(
                  '确定',
                  onPress: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
                Container(
                  width: 1.0,
                  height: 44.0,
                  color: borderColor,
                ),
                button(
                  '取消',
                  onPress: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}