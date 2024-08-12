import 'package:Bubble/person/entity/goods_v_bean.dart';
import 'package:Bubble/res/colors.dart';
import 'package:flutter/cupertino.dart';
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
              color: Colors.white,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colours.color_E9E1FF,
            ),
      margin: EdgeInsets.only(left: 10.w),
      padding: const EdgeInsets.all(15),
      width: 160.w,
      height: 160.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 45.h,
            child: Center(
              child: Text(
                widget.data.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
          widget.data.originalPrice != "0"
              ? Stack(
                  children: [
                    Center(
                      child: Text(
                        "￥${widget.data.originalPrice}",
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(
                          fontSize: 16.0.sp,
                          leading: 0,
                          height: 1.1,
                          // 1.1更居中
                          forceStrutHeight: true, // 关键属性 强制改为文字高度
                        ),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Colours.color_542DEC,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          height: 2,
                          width: creatLine("￥${widget.data.originalPrice}"),
                          color: Colours.color_542DEC,
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  double creatLine(String price) {
    double wei = 0;
    for (int i = 0; i < price.length; i++) {
      wei = wei + 10.w;
    }
    return wei;
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
              color: Colors.white,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colours.color_E9E1FF,
            ),
      margin: EdgeInsets.only(left: 10.w),
      // padding: const EdgeInsets.all(10),
      width: 160.w,
      height: 160.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 45.h,
            child: Center(
              child: Text(
                widget.data.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 18.0.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
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
          widget.data.originalPrice != "0"
              ? Stack(
                  children: [
                    Center(
                      child: Text(
                        "￥${widget.data.originalPrice}",
                        textAlign: TextAlign.center,
                        strutStyle: StrutStyle(
                          fontSize: 16.0.sp,
                          leading: 0,
                          height: 1.1,
                          // 1.1更居中
                          forceStrutHeight: true, // 关键属性 强制改为文字高度
                        ),
                        style: TextStyle(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.w400,
                          color: Colours.color_542DEC,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          height: 2,
                          width: creatLine("￥${widget.data.originalPrice}"),
                          color: Colours.color_542DEC,
                        ),
                      ),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  double creatLine(String price) {
    double wei = 0;
    for (int i = 0; i < price.length; i++) {
      wei = wei + 10.w;
    }
    return wei;
  }
}
