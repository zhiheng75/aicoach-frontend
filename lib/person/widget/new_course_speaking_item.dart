import 'package:Bubble/person/entity/goods_v_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewCourseSpeakingItem extends StatefulWidget {
  final PackageListList data;
  final bool isSele;
  const NewCourseSpeakingItem(
      {super.key, required this.data, required this.isSele});

  @override
  State<NewCourseSpeakingItem> createState() => _NewCourseSpeakingItemState();
}

class _NewCourseSpeakingItemState extends State<NewCourseSpeakingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isSele
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 2.0,
                style: BorderStyle.solid,
                color: Colours.color_8256FF,
              ),
              color: Colours.color_EFE9FF,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
      margin: EdgeInsets.only(right: 10.w, left: 10.w),
      padding: const EdgeInsets.all(15),
      width: 150.w,
      height: 150.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.data.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 18.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "￥",
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_542DEC,
                ),
              ),
              Text(
                widget.data.price,
                style: TextStyle(
                  fontSize: 36.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colours.color_542DEC,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NewCourseSpeakingTwoItem extends StatefulWidget {
  final LessonListList data;
  final bool isSele;
  const NewCourseSpeakingTwoItem(
      {super.key, required this.data, required this.isSele});
  @override
  State<NewCourseSpeakingTwoItem> createState() =>
      _NewCourseSpeakingTwoItemState();
}

class _NewCourseSpeakingTwoItemState extends State<NewCourseSpeakingTwoItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.isSele
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                width: 2.0,
                style: BorderStyle.solid,
                color: Colours.color_8256FF,
              ),
              color: Colours.color_EFE9FF,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
      margin: EdgeInsets.only(right: 10.w, left: 10.w),
      // padding: const EdgeInsets.all(10),
      width: 150.w,
      height: 150.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.data.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              fontSize: 18.0.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "￥",
                style: TextStyle(
                  fontSize: 16.0.sp,
                  fontWeight: FontWeight.w400,
                  color: Colours.color_542DEC,
                ),
              ),
              Text(
                widget.data.price,
                style: TextStyle(
                  fontSize: 36.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colours.color_542DEC,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
