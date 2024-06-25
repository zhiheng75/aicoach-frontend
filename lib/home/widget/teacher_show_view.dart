import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
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
            width: 290,
            // margin: EdgeInsets.all(40),
            padding: const EdgeInsets.only(left: 18, right: 18),
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
                  "尚未添加辅导老师微信",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Gaps.vGap8,
                RichText(
                    // RichText
                    text: const TextSpan(
                        text: '您已成功购买口语课程,',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                        children: <TextSpan>[
                      TextSpan(
                          text: '开课前务必添加辅导老师微信，避免无法正常上课',
                          style: TextStyle(
                            color: Colours.color_FF4343,
                            fontSize: 15.0,
                          )),
                    ])),
                // const Text(
                //   "您已成功购买口语课程，开课前务必添加辅导老师微信，避免无法正常上课",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(fontSize: 15, color: Colors.black),
                // ),
                Gaps.vGap12,
                GestureDetector(
                  onTap: () async {
                    NavigatorUtils.goBack(context);
                    widget._cancelPress();
                  },
                  child: Container(
                    width: 230,
                    // height: 43,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //       image: ImageUtils.getAssetImage(
                    //         "queding_img",
                    //       ),
                    //       fit: BoxFit.fill),
                    // ),
                    child: const LoadAssetImage(
                      "queding_img",
                      // width: 24.0,
                      // height: 24.0,
                    ),
                  ),
                ),
                Gaps.vGap10,
                GestureDetector(
                  onTap: () {
                    NavigatorUtils.goBack(context);
                  },
                  child: Container(
                    width: 114,
                    height: 20,
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //       image: ImageUtils.getAssetImage(
                    //         "quxiao_img",
                    //       ),
                    //       fit: BoxFit.fill),
                    // ),
                    child: const Center(
                      child: Text(
                        "仍不添加",
                        style: TextStyle(
                            fontSize: 13, color: Colours.color_999999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
