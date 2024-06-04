import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:flutter/material.dart';

class TeacherShowView extends StatefulWidget {
  final VoidCallback _cancelPress;
  const TeacherShowView(this._cancelPress, {Key? key}) : super(key: key);

  @override
  State<TeacherShowView> createState() => _TeacherShowViewState();
}

class _TeacherShowViewState extends State<TeacherShowView> {
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
            height: 220,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: ImageUtils.getAssetImage("teach_show_img"),
                  fit: BoxFit.fitHeight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Gaps.vGap24,
                const Text(
                  "课程资料未领取",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                Gaps.vGap8,
                const Text(
                  "添加专属辅导老师微信，\n获取更多学习资料及学习辅导，\n获得更好的上课体验",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black),
                ),
                Gaps.vGap12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.goBack(context);
                      },
                      child: Container(
                        width: 114,
                        height: 43,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage(
                                "quxiao_img",
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: const Center(
                          child: Text(
                            "放弃领取",
                            style: TextStyle(
                                fontSize: 15, color: Colours.color_875EFF),
                          ),
                        ),
                      ),
                    ),
                    Gaps.hGap15,
                    GestureDetector(
                      onTap: () async {
                        NavigatorUtils.goBack(context);
                        widget._cancelPress();
                      },
                      child: Container(
                        width: 114,
                        height: 43,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: ImageUtils.getAssetImage(
                                "queding_img",
                              ),
                              fit: BoxFit.fill),
                        ),
                        child: const Center(
                          child: Text(
                            "立即添加",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
