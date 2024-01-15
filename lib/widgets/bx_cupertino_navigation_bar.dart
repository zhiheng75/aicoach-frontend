// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class XTCupertinoNavigationBar extends StatefulWidget {
  const XTCupertinoNavigationBar({
    Key? key,
    this.leading,
    this.middle,
    this.trailing,
    this.backgroundColor,
    this.padding,
    this.border,
    this.heroTag,
    this.transitionBetweenRoutes = true,
  }) : super(key: key);
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final Color? backgroundColor;
  final EdgeInsetsDirectional? padding;
  final Border? border;
  final Object? heroTag;
  final bool transitionBetweenRoutes;

  @override
  _XTCupertinoNavigationBar createState() => _XTCupertinoNavigationBar();

  Size get preferredSize => const Size.fromHeight(44);

  bool shouldFullyObstruct(BuildContext context) {
    final Color backgroundColor =
        CupertinoDynamicColor.maybeResolve(this.backgroundColor, context) ??
            CupertinoTheme.of(context).barBackgroundColor;
    return backgroundColor.alpha == 0xFF;
  }
}

class _XTCupertinoNavigationBar extends State<XTCupertinoNavigationBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.heroTag == null
            ? CupertinoNavigationBar(
                key: widget.key,
                transitionBetweenRoutes: widget.transitionBetweenRoutes,
                border: widget.border,
                backgroundColor: widget.backgroundColor,
                leading: widget.leading,
                padding: widget.padding,
                middle: widget.middle,
                trailing: widget.trailing,
              )
            : CupertinoNavigationBar(
                key: widget.key,
                transitionBetweenRoutes: widget.transitionBetweenRoutes,
                heroTag: widget.heroTag!,
                border: widget.border,
                backgroundColor: widget.backgroundColor,
                leading: widget.leading,
                padding: widget.padding,
                middle: widget.middle,
                trailing: widget.trailing,
              ),
      ],
    );
  }
}

int? gCodePoint;

class NavigationBackWidget extends StatelessWidget {
  final Function? onBack;
  final Color color;
  final double width;
  final double height;
  final double widthIcon;
  final double heightIcon;
  final Alignment alignment;
  final EdgeInsetsGeometry padding;
  final int? leftIconPoint;
  final double size;

  static setBackCodePoint(int codePoint) {
    gCodePoint = codePoint;
  }

  const NavigationBackWidget(
      {super.key,
      this.color = const Color(0xff333333),
      this.width = 40,
      this.height = 40,
      this.widthIcon = 20,
      this.heightIcon = 20,
      this.size = 20,
      this.onBack,
      this.leftIconPoint,
      this.alignment = Alignment.centerLeft,
      this.padding = const EdgeInsets.only(left: 7)});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (onBack != null) {
          return onBack!();
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          final isBack = await Navigator.maybePop(context);
          if (!isBack) {
            await SystemNavigator.pop();
          }
        }
      },
      child: Container(
        // color: Colors.black,
        alignment: alignment,
        width: width,
        height: height,
        padding: padding,
        child: SizedBox(
          width: widthIcon,
          height: heightIcon,
          child: Image.asset(
            width: 10,
            height: 16,
            'assets/images/ic_back_icon.png',
          ),
        ),
      ),
    );
  }
}
