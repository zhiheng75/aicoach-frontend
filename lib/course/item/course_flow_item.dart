import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:Bubble/course/entity/step_detail_bean.dart';

class CourseFlowItem extends StatefulWidget {
  final CourseDatum data;

  const CourseFlowItem({super.key, required this.data});

  @override
  State<CourseFlowItem> createState() => _CourseFlowItemState();
}

class _CourseFlowItemState extends State<CourseFlowItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
      height: 80,
      // width: 280,
      padding: const EdgeInsets.all(0.5),
      decoration: widget.data.completed == 1
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  Colours.color_9AC3FF,
                  Colours.color_FF71E0,
                ],
              ))
          : BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color.fromRGBO(248, 248, 248, 1)),
      child: Container(
        alignment: Alignment.center,
        decoration: widget.data.completed == 1
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
        child: Container(
          margin: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Gaps.hGap10,
              LoadAssetImage(
                imgStr(widget.data.stepIcon),
                width: 40.0,
                height: 40.0,
              ),
              Gaps.hGap8,
              Expanded(
                child: Text(
                  widget.data.stepName,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              Gaps.hGap10,
              widget.data.isLocked == 0
                  ? Text(
                      widget.data.completed == 0 ? "去上课" : "已完成",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: widget.data.completed == 0
                            ? Colours.color_00BB40
                            : Colours.color_666666,
                      ),
                    )
                  : const LoadAssetImage(
                      "locked_icon",
                      width: 24.0,
                      height: 24.0,
                    ),
              // Text(
              //   // ignore: unrelated_type_equality_checks
              //   widget.data.completed == 1 ? "已完成" : "去完成",
              //   style: TextStyle(
              //     fontSize: 16.0,
              //     fontWeight: FontWeight.w400,
              //     // color: Colours.color_00BB40,
              //     color: widget.data.completed == 1
              //         ? Colours.color_666666
              //         : Colours.color_00BB40,
              //   ),
              // ),
              // Gaps.hGap10,
            ],
          ),
        ),
      ),
    );
  }

  String imgStr(int stepIconStr) {
    //  widget.data.stepIcon
    if (stepIconStr == 1) {
      return "video_icon";
    } else if (stepIconStr == 2 || stepIconStr == 3) {
      return "danci_icon";
    } else if (stepIconStr == 4 || stepIconStr == 5) {
      return "juxing_icon";
    } else {
      return "qingjing_icon";
    }
  }
}
