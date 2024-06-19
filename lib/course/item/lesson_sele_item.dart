import 'package:Bubble/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LessonSeleItem extends StatefulWidget {
  final String tit;
  final bool sele;
  const LessonSeleItem({super.key, required this.tit, required this.sele});

  @override
  State<LessonSeleItem> createState() => _LessonSeleItemState();
}

class _LessonSeleItemState extends State<LessonSeleItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 50,
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 10, left: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: widget.sele ? Colours.color_007AFF : Colours.color_F9F8FF,
      ),
      padding: const EdgeInsets.only(right: 8, left: 8.0),
      child: Center(
          child: Text(
        widget.tit,
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: widget.sele ? Colors.white : Colors.black,
        ),
      )),
    );
  }
}
