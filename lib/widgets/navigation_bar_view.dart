import 'package:Bubble/util/jh_screen_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NavigationBaView extends StatefulWidget {
  final String title;
  const NavigationBaView({super.key, required this.title});

  @override
  State<NavigationBaView> createState() => _NavigationBaViewState();
}

class _NavigationBaViewState extends State<NavigationBaView> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: _screenUtil.screenWidth,
      height: 44, //JhScreenUtils.navigationBarHeight,
      child: Center(
          child: Text(widget.title,
              style: TextStyle(fontWeight: FontWeight.bold))),
    );
  }
}
