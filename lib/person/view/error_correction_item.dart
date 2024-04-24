import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flutter/material.dart';

class ErrorCorrectionItem extends StatefulWidget {
  const ErrorCorrectionItem({super.key});

  @override
  State<ErrorCorrectionItem> createState() => _ErrorCorrectionItemState();
}

class _ErrorCorrectionItemState extends State<ErrorCorrectionItem> {
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
                    "农场里面的动物",
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
                    '学习时间:2024年4月30号',
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
              "去纠错",
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
