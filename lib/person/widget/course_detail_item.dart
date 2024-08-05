import 'package:Bubble/person/entity/goods_v_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseDetaiItem extends StatefulWidget {
  final LessonListClass unitData;
  final Color backColor;
  final List<Color> iconBackColor;
  const CourseDetaiItem({
    super.key,
    required this.unitData,
    required this.backColor,
    required this.iconBackColor,
  });

  @override
  State<CourseDetaiItem> createState() => _CourseDetaiItemState();
}

class _CourseDetaiItemState extends State<CourseDetaiItem> {
  String nengli = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < widget.unitData.objectives.speakingSkills.length; i++) {
      if (i == 0) {
        nengli = widget.unitData.objectives.speakingSkills[i].skill;
      } else {
        nengli =
            "$nengli ${widget.unitData.objectives.speakingSkills[i].skill}";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 104.h,
        margin: const EdgeInsets.only(top: 10, left: 16, right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
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
              // padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                    widget.unitData.lessonDescription != ""
                        ? widget.unitData.lessonDescription
                        : nengli,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                      color: Colours.color_666666,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.hGap10,
          ],
        ));
  }
}
