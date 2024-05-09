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
      margin: const EdgeInsets.all(8),
      height: 80,
      // width: 280,
      padding: const EdgeInsets.all(0.5),
      decoration: widget.data.completed
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Colours.color_9AC3FF,
                  Colours.color_FF71E0,
                ],
              ))
          : BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: const Color.fromRGBO(248, 248, 248, 1)),
      child: Container(
        alignment: Alignment.center,
        decoration: widget.data.completed
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              )
            : BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.hGap10,
            Container(
              width: 40,
              height: 40,
              // margin: const EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colours.color_F3E4FF,
              ),
              padding: const EdgeInsets.all(10),
//video_icon
// word_icon
// sentence_icon
// scene_icon
              child: const LoadAssetImage(
                "video_icon",
                width: 24.0,
                height: 24.0,
              ),
            ),
            Gaps.hGap10,
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
            Text(
              // ignore: unrelated_type_equality_checks
              widget.data.completed ? "已完成" : "去完成",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                // color: Colours.color_00BB40,
                color: widget.data.completed
                    ? Colours.color_666666
                    : Colours.color_00BB40,
              ),
            ),
            Gaps.hGap10,
          ],
        ),
      ),
    );
//     return Container(
//         // height: 120,
//         margin: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10.0),
//           // color: Colours.color_F8F8F8,
//           border: Border.all(color: Colors.black, width: 1.0),
//           gradient: const LinearGradient(
//             begin: Alignment.bottomLeft,
//             end: Alignment.topRight,
//             colors: [
//               Colours.color_9AC3FF,
//               Colours.color_FF71E0,
//             ],
//           ),
//           color: Colors.white,
//         ),
//         padding: const EdgeInsets.symmetric(
//           horizontal: 5.0,
//           vertical: 15.0,
//         ),
//         // height: 120,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Gaps.hGap10,
//             Container(
//               width: 40,
//               height: 40,
//               // margin: const EdgeInsets.only(top: 10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 color: Colors.white,
//               ),
//               padding: const EdgeInsets.all(10),
//               // padding: const EdgeInsets.symmetric(
//               //   horizontal: 10.0,
//               //   vertical: 10.0,
//               // ),
//               //video_icon
// // word_icon
// // sentence_icon
// // scene_icon
//               child: const LoadAssetImage(
//                 "video_icon",
//                 width: 24.0,
//                 height: 24.0,
//               ),
//             ),
//             Gaps.hGap10,
//             const Expanded(
//               child: Text(
//                 '视频预习',
//                 style: TextStyle(
//                   fontSize: 17.0,
//                   fontWeight: FontWeight.w400,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Gaps.hGap10,
//             const Text(
//               "已完成",
//               style: TextStyle(
//                 fontSize: 16.0,
//                 fontWeight: FontWeight.w400,
//                 // color: Colours.color_00BB40,
//                 color: Colours.color_666666,
//               ),
//             ),
//             Gaps.hGap10,
//           ],
//         ));
  }
}
