import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Bubble/chat/entity/character_list_bean.dart';

class SwitchingTeacherItem extends StatefulWidget {
  final Datum data;
  const SwitchingTeacherItem({super.key, required this.data});

  @override
  State<SwitchingTeacherItem> createState() => _SwitchingTeacherItemState();
}

class _SwitchingTeacherItemState extends State<SwitchingTeacherItem> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              // margin: const EdgeInsets.only(
              //     top: 0, left: 8, right: 8, bottom: 0),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8.0),
              // image: const DecorationImage(
              //   image: AssetImage(
              //     'assets/images/mkbg.png',
              //   ),
              //   fit: BoxFit.cover,
              // ),
              // ),
              child: LoadImage(
                widget.data.imageUrl,
                fit: BoxFit.fill,
                width: _screenUtil.screenWidth / 2 - 20,
                height: _screenUtil.screenWidth / 2 + 30,
              )),
        ),
        // Gaps.vGap4,

        Positioned(
            right: 20,
            top: 20,
            child: Image.asset(
              'assets/images/shengwen.gif',
              width: 35,
              height: 25,
              fit: BoxFit.fitWidth,
            )),
        Positioned(
          // right: 15,
          bottom: 10,
          right: 10,
          left: 10,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0)),
              color: Colours.color_292A2E,
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gaps.vGap4,
                Text(
                  widget.data.name,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.data.slogan,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_999999,
                  ),
                ),
                // Gaps.vGap4,
              ],
            ),
          ),
        ),
        const Positioned(
            right: 15,
            bottom: 70,
            child: LoadAssetImage(
              "play_teacher_icon",
              width: 32.0,
              height: 32.0,
            )),
      ],
    );
  }
}
