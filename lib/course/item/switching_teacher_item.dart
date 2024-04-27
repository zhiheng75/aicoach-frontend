import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SwitchingTeacherItem extends StatefulWidget {
  const SwitchingTeacherItem({super.key});

  @override
  State<SwitchingTeacherItem> createState() => _SwitchingTeacherItemState();
}

class _SwitchingTeacherItemState extends State<SwitchingTeacherItem> {
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colours.color_292A2E,
      ),
      // color: Colors.red,
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
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
                    "https://statics.shenmo-ai.com/sophia.jpg",
                    fit: BoxFit.fill,
                    width: _screenUtil.screenWidth / 2 - 20,
                    height: _screenUtil.screenWidth / 2 - 20,
                  )),
              Gaps.vGap4,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Anela",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "洛杉矶大学",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colours.color_999999,
                        ),
                      ),
                    ],
                  ),
                  Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      padding: const EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colours.color_C8F5B1,
                      ),
                      child: const Text(
                        "高级老师",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      )),
                ],
              ),
            ],
          ),
          const Positioned(
              right: 15,
              bottom: 60,
              child: LoadAssetImage(
                "play_teacher_icon",
                width: 32.0,
                height: 32.0,
              )),
          Positioned(
              right: 15,
              top: 10,
              child: Image.asset(
                'assets/images/shengwen.gif',
                width: 35,
                height: 25,
                fit: BoxFit.fitWidth,
              )),
        ],
      ),
    );
  }
}
