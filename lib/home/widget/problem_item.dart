import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProblemItem extends StatefulWidget {
  const ProblemItem({super.key});

  @override
  State<ProblemItem> createState() => _ProblemItemState();
}

class _ProblemItemState extends State<ProblemItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.vGap8,
        const Text(
          "1,关于选课",
          style: TextStyle(
            fontSize: 17.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 15.0,
          ),
          child: RichText(
            text: const TextSpan(children: [
              TextSpan(
                  text: '问题：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_FF71CF,
                  )),
              TextSpan(
                  text: "内容表述位置问题内容表述位置问题内容表述位置问题内容表述位置？",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  )),
            ]),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 15.0,
          ),
          child: RichText(
            text: const TextSpan(children: [
              TextSpan(
                  text: '解答：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_FF71CF,
                  )),
              TextSpan(
                  text: "解答：内容表述位置问题内容表述位置问题内容表述位置问题内容表述位置？",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  )),
            ]),
          ),
        ),
      ],
    );
  }
}
