import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseShowView extends StatefulWidget {
  final String message;
  const CourseShowView({Key? key, required this.message}) : super(key: key);

  @override
  State<CourseShowView> createState() => _CourseShowViewState();
}

class _CourseShowViewState extends State<CourseShowView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            height: 220.h,
            width: 270.w,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage("course_show_img"),
                  fit: BoxFit.fitWidth),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap70,
                const Text(
                  "您已购买课程",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Gaps.vGap8,
                Text(
                  "课程将在${widget.message}解锁",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Gaps.vGap24,
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.goBack(context);
                  },
                  child: const LoadAssetImage(
                    'course_ok',
                    width: 116.0,
                    height: 42.0,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
