import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseHomeItem extends StatefulWidget {
  const CourseHomeItem({super.key});

  @override
  State<CourseHomeItem> createState() => _CourseHomeItemState();
}

class _CourseHomeItemState extends State<CourseHomeItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.hGap10,
            SizedBox(
              width: 80.0,
              height: 100.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: const LoadImage(
                  "https://statics.shenmo-ai.com/sophia.jpg",
                  width: 118.0,
                ),
              ),
            ),
            Gaps.hGap10,
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "课程名",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 18.0 / 16.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '副标题',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                      height: 18.0 / 14.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                  Text(
                    '巴拉巴拉',
                    style: TextStyle(
                      fontSize: 11.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_999999,
                      height: 18.0 / 11.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.hGap10,
            const Text("unit"),
            Gaps.hGap10,
          ],
        ));
  }
}
