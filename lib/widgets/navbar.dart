import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'load_image.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    Key? key,
    required this.title,
    this.margin,
    this.action,
  }) : super(key: key);

  final String title;
  final double? margin;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();

    double width = screenUtil.screenWidth - (margin ?? 16.0) * 2;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            color: Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                letterSpacing: 0.05,
              ),
            ),
          ),
          Positioned(
            left: 0,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40.0,
                alignment: Alignment.centerLeft,
                child: const LoadAssetImage(
                  'navbar_back',
                  width: 18.2,
                  height: 22.0,
                ),
              ),
            ),
          ),
          if (action != null)
            Positioned(
              right: 0,
              child: action!,
            ),
        ],
      ),
    );
  }
}
