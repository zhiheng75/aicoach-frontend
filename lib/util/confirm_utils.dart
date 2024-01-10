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
    Widget? child,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (_) => Confirm(
        title: title,
        buttonDirection: buttonDirection,
        confirmButtonText: confirmButtonText,
        cancelButtonText: cancelButtonText,
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
    this.buttonDirection = 'horizontal',
    this.confirmButtonText,
    this.cancelButtonText,
    required this.onConfirm,
    this.child,
  }) : super(key: key);

  final String title;
  final String? buttonDirection;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final Function() onConfirm;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();
    Color borderColor = const Color(0xFF3C3C43).withOpacity(0.36);

    Widget button(String text, {
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

    Widget bottomButton = buttonDirection == 'vertical' ? Column(
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
          },
        ),
      ],
    ) : Row(
      children: <Widget>[
        Expanded(
          child: button(
            '确定',
            onPress: () {
              Navigator.of(context).pop();
              onConfirm();
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
            cancelButtonText ?? '取消',
            onPress: () {
              Navigator.of(context).pop();
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