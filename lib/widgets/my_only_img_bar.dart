import 'package:Bubble/widgets/my_img_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/util/theme_utils.dart';

import '../res/colors.dart';
import '../res/dimens.dart';
import '../res/gaps.dart';
import 'my_button.dart';

/// 自定义AppBar
class MyOnlyImgBar extends StatelessWidget implements PreferredSizeWidget {
  const MyOnlyImgBar({
    super.key,
    this.backgroundColor,
    this.centerTitle = '',
    this.actionName = '',
    this.backImgColor,
    this.actionUrl = "",
    this.onActionPress,
    this.height = 20.0,
    this.width = 20.0,
    this.alignment = Alignment.centerRight,
  });

  final Color? backgroundColor;
  final String centerTitle;
  final Color? backImgColor;
  final String actionName;
  final String actionUrl;
  final double height;
  final double width;
  final VoidCallback? onActionPress;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? context.backgroundColor;

    final SystemUiOverlayStyle overlayStyle =
        ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    final Widget actionImgBtn = actionUrl.isNotEmpty
        ? MyImgButton(
            minHeight: height,
            minWidth: width,
            onPressed: onActionPress,
            url: actionUrl)
        : Gaps.empty;

    final Widget titleWidget = Semantics(
      namesRoute: true,
      header: true,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 48.0),
        child: Text(
          centerTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: Dimens.font_sp18,
          ),
        ),
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Material(
        color: bgColor,
        child: SafeArea(
          child: Stack(
            alignment: alignment,
            children: <Widget>[
              titleWidget,
              actionImgBtn,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48.0);
}
