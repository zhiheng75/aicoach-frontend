import 'package:Bubble/res/colors.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Example extends StatelessWidget {
  Example({
    Key? key,
    required this.text,
    required this.textZh,
    required this.audio,
  }) : super(key: key);

  final String text;
  final String textZh;
  final String audio;

  @override
  Widget build(BuildContext context) {
    final ScreenUtil screenUtil = ScreenUtil();

    return Stack(
      children: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            width: screenUtil.screenWidth,
            height: screenUtil.screenHeight,
            color: Colors.transparent,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            width: screenUtil.screenWidth,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              color: const Color(0xFF000101).withOpacity(0.9),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '示例',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_999999,
                    height: 18.0 / 12.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFFFF5BF),
                    height: 18.0 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Text(
                  textZh,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 18.0 / 14.0,
                    letterSpacing: 0.05,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: const LoadAssetImage(
                    'laba',
                    width: 17.6,
                    height: 16.0,
                  ),
                ),
                SizedBox(
                  height: screenUtil.bottomBarHeight,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
