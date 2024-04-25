import 'package:Bubble/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseReportSelectItem extends StatefulWidget {
  const CourseReportSelectItem({super.key});

  @override
  State<CourseReportSelectItem> createState() => _CourseReportSelectItemState();
}

class _CourseReportSelectItemState extends State<CourseReportSelectItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(5),
        // height: 80,
        // width: 280,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: const LinearGradient(
              colors: [
                Colours.color_E8CCFE,
                Colours.color_ACCDFF,
              ],
            )),
        child: RichText(
          text: const TextSpan(children: [
            TextSpan(
                text: '词汇',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                )),
            TextSpan(
                text: "12",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_FF71CF,
                )),
            TextSpan(
                text: '个',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                )),
          ]),
        ));
  }
}
