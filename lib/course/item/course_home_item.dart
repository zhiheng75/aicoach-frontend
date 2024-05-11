import 'package:Bubble/course/entity/lesson_list_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class CourseHomeItem extends StatefulWidget {
  final int index;
  final UnitList unitData;
  final Color backColor;
  final List<Color> iconBackColor;
  const CourseHomeItem({
    super.key,
    required this.unitData,
    required this.index,
    required this.backColor,
    required this.iconBackColor,
  });

  @override
  State<CourseHomeItem> createState() => _CourseHomeItemState();
}

class _CourseHomeItemState extends State<CourseHomeItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 120,
        margin: const EdgeInsets.all(10),
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
              width: 80,
              height: 80,
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
                    widget.index.toString(),
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "Lesson",
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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
                    widget.unitData.lessonType,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                  Text(
                    widget.unitData.objectives,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.hGap10,
            widget.unitData.isLocked == 0
                ? Text(
                    widget.unitData.completed == 0 ? "去上课" : "已完成",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                      color: widget.unitData.completed == 0
                          ? Colours.color_00BB40
                          : Colours.color_666666,
                    ),
                  )
                : const LoadAssetImage(
                    "locked_icon",
                    width: 24.0,
                    height: 24.0,
                  ),
            Gaps.hGap10,
          ],
        ));
  }
}
