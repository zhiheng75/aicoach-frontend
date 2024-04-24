import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorCorrectionDetailPage extends StatefulWidget {
  const ErrorCorrectionDetailPage({super.key});

  @override
  State<ErrorCorrectionDetailPage> createState() =>
      _ErrorCorrectionDetailPageState();
}

class _ErrorCorrectionDetailPageState extends State<ErrorCorrectionDetailPage> {
  Widget item() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "我的回答",
            style: TextStyle(
              backgroundColor: Colors.yellow,
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
          Gaps.vGap8,
          Container(
            // margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Really? Awesome， Awesome，Behind me are the Alps，Now I'm going skiing，shall we go？",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Gaps.hGap16,
                Column(
                  children: [
                    const Text(
                      "14+",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.vGap8,
                    const LoadAssetImage(
                      'laba_lan',
                      width: 17.6,
                      height: 16.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget notReachItem() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "未更正",
            style: TextStyle(
              backgroundColor: Colors.yellow,
              fontSize: 17.0,
              color: Colors.black,
            ),
          ),
          Gaps.vGap8,
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: const Expanded(
              child: Text(
                "你还未更正读音喔~",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colours.color_999999,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "纠错",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
        child: MyScrollView(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "Unit2 朋友见面",
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colours.color_F8F8F8,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 18.0,
                vertical: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Really? Awesome， Awesome，Behind me are the Alps，Now I'm going skiing，shall we go？",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    ),
                  ),
                  item(),
                  item(),
                  notReachItem(),
                ],
              ),
            ),
            Gaps.vGap30,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colours.color_F8F8F8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10.0,
                  ),
                  child: const Text(
                    "下一页",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colours.color_F8F8F8,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10.0,
                  ),
                  child: const Text(
                    "上一页",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Gaps.vGap30,
            Text("按住说话"),
          ],
        ),
      )),
    );
  }
}
