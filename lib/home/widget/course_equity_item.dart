import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseEquityItem extends StatefulWidget {
  final int idx;

  const CourseEquityItem({super.key, required this.idx});

  @override
  State<CourseEquityItem> createState() => _CourseEquityItemState();
}

class _CourseEquityItemState extends State<CourseEquityItem> {
  late Widget titWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.idx == 0) {
      titWidget = RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: "1.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: "制定专属每日",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: '学习任务',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colours.color_FF71CF,
              )),
        ]),
      );
    } else if (widget.idx == 1) {
      titWidget = RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: "2.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: "辅导老师跟盯",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: '学习任务',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colours.color_FF71CF,
              )),
          TextSpan(
              text: "周周清",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ]),
      );
    } else if (widget.idx == 2) {
      titWidget = RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: "3.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: '1对1辅导',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colours.color_FF71CF,
              )),
          TextSpan(
              text: "专属答疑和",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: "学情反馈",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ]),
      );
    } else if (widget.idx == 3) {
      titWidget = RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: "4.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: "学习群领取",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: '学习物料',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colours.color_FF71CF,
              )),
          TextSpan(
              text: "加速包",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ]),
      );
    } else if (widget.idx == 4) {
      titWidget = RichText(
        text: const TextSpan(children: [
          TextSpan(
              text: "5.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: "学习营坚持学习领取",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
          TextSpan(
              text: '奖学金',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colours.color_FF71CF,
              )),
          TextSpan(
              text: "活动",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              )),
        ]),
      );
    } else if (widget.idx == 5) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 60,
      // width: 280,
      padding: const EdgeInsets.all(0.5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Colours.color_9AC3FF,
              Colours.color_FF71E0,
            ],
          )),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.hGap10,
            Expanded(
              child: titWidget,
            ),
            Gaps.hGap10,
            const LoadAssetImage(
              "quanyi_icon",
              width: 40.0,
              height: 40.0,
            ),
            Gaps.hGap10,
          ],
        ),
      ),
    );
  }
}
