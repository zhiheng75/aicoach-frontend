import 'package:Bubble/report/entity/lesson_reports_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseReportClassItem extends StatefulWidget {
  final int index;
  final ListList unitData;
  final Color backColor;
  final List<Color> iconBackColor;
  const CourseReportClassItem({
    super.key,
    required this.unitData,
    required this.index,
    required this.backColor,
    required this.iconBackColor,
  });
  @override
  State<CourseReportClassItem> createState() => _CourseReportClassItemState();
}

class _CourseReportClassItemState extends State<CourseReportClassItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 120,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: widget.backColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: 15.0,
        ),
        // height: 120,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.hGap10,
            Container(
              width: 64,
              height: 64,
              // margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: widget.iconBackColor,
                  )),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(8.0),
              //   color: Colors.white,
              // ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 10.0,
              //   vertical: 10.0,
              // ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.unitData.lessonLabel,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    "Lesson",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colours.color_FFFFFF60,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.hGap10,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.unitData.lessonName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    "学习时间:${widget.unitData.createdAt}",
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  star(widget.unitData.score.toInt()),

                  // Text(
                  //   "综合得分:${widget.unitData.score}分 ",
                  //   style: const TextStyle(
                  //     fontSize: 13.0,
                  //     fontWeight: FontWeight.w400,
                  //     color: Colours.color_666666,
                  //   ),
                  // ),
                ],
              ),
            ),
            Gaps.hGap10,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${widget.unitData.score}',
                      style: TextStyle(
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                        color:
                            getColorByScore(widget.unitData.score.toDouble()),
                        letterSpacing: 0.05,
                      ),
                    ),
                    const Text(
                      '综合得分',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_999999,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 7.0,
                // ),
              ],
            ),
            // Gaps.hGap2,
            // Text(
            //   widget.unitData.completed == 0 ? "去上课" : "已完成",
            //   style: TextStyle(
            //     fontSize: 16.0,
            //     fontWeight: FontWeight.w400,
            //     color: widget.unitData.completed == 0
            //         ? Colours.color_00BB40
            //         : Colours.color_666666,
            //   ),
            // ),
            const LoadAssetImage(
              "ic_arrow_right",
              width: 24.0,
              height: 24.0,
            ),
            // Gaps.hGap2,

            // Gaps.hGap10,
          ],
        ));
  }

  Color getColorByScore(double score) {
    Color color;
    if (score < 50) {
      color = const Color(0xFFE00094);
    } else if (score < 80) {
      color = const Color(0xFF020000);
    } else {
      color = const Color(0xFF24B340);
    }
    return color;
  }

  Widget star(num score) {
    List<Widget> children = [];
    int count = 0;
    if (score >= 92) {
      count = 5;
    } else if (score >= 80) {
      count = 4;
    } else if (score >= 60) {
      count = 3;
    } else if (score >= 50) {
      count = 2;
    } else {
      count = 1;
    }
    while (count > 0) {
      children.add(const LoadAssetImage(
        'star',
        width: 16.0,
        height: 15.0,
      ));
      count--;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}
