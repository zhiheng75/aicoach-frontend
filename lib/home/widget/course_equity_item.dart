import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseEquityItem extends StatefulWidget {
  const CourseEquityItem({super.key});

  @override
  State<CourseEquityItem> createState() => _CourseEquityItemState();
}

class _CourseEquityItemState extends State<CourseEquityItem> {
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
              child: RichText(
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
              ),
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
