import 'package:Bubble/home/page/entity/lesson_detail_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProblemItem extends StatefulWidget {
  final Question questions;
  const ProblemItem({super.key, required this.questions});

  @override
  State<ProblemItem> createState() => _ProblemItemState();
}

class _ProblemItemState extends State<ProblemItem> {
  final ScreenUtil _screenUtil = ScreenUtil();

  Widget contenWidget(
    String qu,
    String an,
  ) {
    return Column(
      children: [
        Container(
          width: _screenUtil.screenWidth - 40,
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
            text: TextSpan(children: [
              const TextSpan(
                  text: '问题：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_FF71CF,
                  )),
              TextSpan(
                  text: widget.questions.list[0].q,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  )),
            ]),
          ),
        ),
        Container(
          width: _screenUtil.screenWidth - 40,
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
            text: TextSpan(children: [
              const TextSpan(
                  text: '解答：',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_FF71CF,
                  )),
              TextSpan(
                  text: widget.questions.list[0].a,
                  style: const TextStyle(
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

  List<Widget> _buildItems() {
    List<Widget> list = [];
    for (int i = 0; i < widget.questions.list.length; i++) {
      list.add(
          contenWidget(widget.questions.list[i].q, widget.questions.list[i].a));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _screenUtil.screenWidth - 40,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.vGap8,
          Container(
            color: Colors.amber,
            child: Text(
              widget.questions.questionType,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Column(
            children: _buildItems(),
          ),
        ],
      ),
    );
  }
}
