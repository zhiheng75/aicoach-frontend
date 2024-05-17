//认证学习
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CertifiedLearningPage extends StatefulWidget {
  const CertifiedLearningPage({super.key});

  @override
  State<CertifiedLearningPage> createState() => _CertifiedLearningPageState();
}

class _CertifiedLearningPageState extends State<CertifiedLearningPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "获得证书",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
              child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const LoadImage(
              "https://statics.shenmo-ai.com/sophia.jpg",
              width: 200.0,
              height: 200,
            ),
            Gaps.vGap8,
            const Text(
              "¥2109元",
              style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_BA995A,
              ),
            ),
            Gaps.vGap8,
            const Text(
              "获得条件",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_BA995A,
              ),
            ),
            Gaps.vGap8,
            const Text(
              "加入训练营完成学习任务，且总测试分数在60分以上",
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_BA995A,
              ),
            ),
            Gaps.vGap8,
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Center(
                child: Container(
                  width: 250.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    // border: Border.all(
                    //   width: 1.0,
                    //   style: BorderStyle.solid,
                    //   color: Colours.color_001652,
                    // ),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Colours.color_9AC3FF,
                        Colours.color_FF71E0,
                      ],
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '立即购买',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_001652,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ))),
    );
  }
}
