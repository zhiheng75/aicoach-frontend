import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmUtils {
  static void show({
    required BuildContext context,
    required String title,
    String? buttonDirection,
    String? confirmButtonText,
    String? cancelButtonText,
    required Function() onConfirm,
    required Function() onCancel,
    Widget? child,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      // ignore: deprecated_member_use
      builder: (_) => WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          return false;
        },
        child: ConfirmTwo(
          title: title,
          buttonDirection: buttonDirection,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText,
          onConfirm: onConfirm,
          onCancel: onCancel,
          child: child,
        ),
      ),
    );
  }

  static void showSingle({
    required BuildContext context,
    required String title,
    String? cancelButtonText,
    required Function() onCancel,
    Widget? child,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => SingleChoice(
        title: title,
        cancelButtonText: cancelButtonText,
        onCancel: onCancel,
        child: child,
      ),
    );
  }
}

class SingleChoice extends StatelessWidget {
  const SingleChoice({
    Key? key,
    required this.title,
    this.cancelButtonText,
    required this.onCancel,
    this.child,
  }) : super(key: key);

  final String title;
  final String? cancelButtonText;
  final Function() onCancel;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();
    Color borderColor = const Color(0xFF3C3C43).withOpacity(0.36);

    Widget button(
      String text, {
      required Function() onPress,
    }) {
      return GestureDetector(
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
      );
    }

    Widget bottomButton = button(
      cancelButtonText ?? '确定',
      onPress: () {
        Navigator.of(context).pop();
        onCancel();
      },
    );

    return Material(
      color: Colors.transparent,
      child: Container(
        width: screenUtil.screenWidth,
        color: Colors.black.withOpacity(0.6),
        alignment: Alignment.center,
        child: Container(
          width: 270.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: const Color(0xFFB3B3B3),
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
                  textAlign: TextAlign.center,
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
              bottomButton,
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmTwo extends StatelessWidget {
  const ConfirmTwo({
    Key? key,
    required this.title,
    this.buttonDirection = 'horizontal',
    this.confirmButtonText,
    this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
    this.child,
  }) : super(key: key);

  final String title;
  final String? buttonDirection;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Function() onConfirm;
  final Function() onCancel;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();

    return Material(
      color: Colors.transparent,
      child: Container(
        width: screenUtil.screenWidth,
        color: Colors.black.withOpacity(0.6),
        alignment: Alignment.center,
        child: Container(
          margin:
              // isIPad ? const EdgeInsets.all(100) : const EdgeInsets.all(30),
              EdgeInsets.all(30.w),
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Gaps.vGap24,
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 22.0 / 17.0,
                ),
              ),
              if (child != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: child!,
                ),
              Gaps.vGap26,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      NavigatorUtils.goBack(context);
                      onCancel();
                    },
                    child: Container(
                      width: 100.w,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colours.color_F2F3F5,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          cancelButtonText ?? '取消',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  // Gaps.hGap10,
                  GestureDetector(
                    onTap: () async {
                      NavigatorUtils.goBack(context);
                      onConfirm();
                    },
                    child: Container(
                      width: 100.w,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colours.color_8003FD,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          confirmButtonText ?? '确定',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Confirm extends StatelessWidget {
  const Confirm({
    Key? key,
    required this.title,
    this.buttonDirection = 'horizontal',
    this.confirmButtonText,
    this.cancelButtonText,
    required this.onConfirm,
    required this.onCancel,
    this.child,
  }) : super(key: key);

  final String title;
  final String? buttonDirection;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Function() onConfirm;
  final Function() onCancel;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();
    Color borderColor = const Color(0xFF3C3C43).withOpacity(0.36);

    Widget button(
      String text, {
      required Function() onPress,
    }) {
      return GestureDetector(
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
      );
    }

    Widget bottomButton = buttonDirection == 'vertical'
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              button(
                confirmButtonText ?? '确定',
                onPress: () {
                  Navigator.of(context).pop();
                  onConfirm();
                },
              ),
              button(
                cancelButtonText ?? '取消',
                onPress: () {
                  Navigator.of(context).pop();
                  onCancel();
                },
              ),
            ],
          )
        : Row(
            children: <Widget>[
              Expanded(
                child: button(
                  cancelButtonText ?? '取消',
                  onPress: () {
                    Navigator.of(context).pop();
                    onCancel();
                  },
                ),
              ),
              Container(
                width: 1.0,
                height: 44.0,
                color: borderColor,
              ),
              Expanded(
                child: button(
                  confirmButtonText ?? '确定',
                  onPress: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
              ),
            ],
          );

    return Material(
      color: Colors.transparent,
      child: Container(
        width: screenUtil.screenWidth,
        color: Colors.black.withOpacity(0.6),
        alignment: Alignment.center,
        child: Container(
          width: 270.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.0),
            color: const Color(0xFFB3B3B3),
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
              bottomButton,
            ],
          ),
        ),
      ),
    );
  }
}
