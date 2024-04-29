import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';

class CourseHomeItem extends StatefulWidget {
  // final int index;
  const CourseHomeItem({super.key});

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
          color: Colours.color_F8F8F8,
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
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              // padding: const EdgeInsets.symmetric(
              //   horizontal: 10.0,
              //   vertical: 10.0,
              // ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "1",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  Text(
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Animals on the Farm",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'words & sentences',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                  Text(
                    'Expressing Opinions/Describepictures',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.hGap10,
            const Text(
              "去上课",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_00BB40,
              ),
            ),
            Gaps.hGap10,
          ],
        ));
  }
}
