import 'package:Bubble/chat/utils/chat_websocket.dart';
import 'package:Bubble/chat/widget/bottom_bar.dart';
import 'package:Bubble/chat/widget/bottom_error_bar.dart';
import 'package:Bubble/chat/widget/record.dart';
import 'package:Bubble/person/item/error_correction_detail_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/my_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorCorrectionDetailPage extends StatefulWidget {
  const ErrorCorrectionDetailPage({super.key});

  @override
  State<ErrorCorrectionDetailPage> createState() =>
      _ErrorCorrectionDetailPageState();
}

class _ErrorCorrectionDetailPageState extends State<ErrorCorrectionDetailPage> {
  final ChatWebsocket _chatWebsocket = ChatWebsocket();
  // 底部按钮控制器
  final BottomErrorBarController _bottomBarControll =
      BottomErrorBarController();
  // 录音界面控制器
  final RecordController _recordController = RecordController();
  final ScreenUtil _screenUtil = ScreenUtil();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bottomBarControll.setDisabled(false);
  }

  Widget notReachItem() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            height: 25,
            // color: Colors.red,
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 3,
                  child: Container(
                    width: 45,
                    height: 15,
                    color: Colours.color_FFD076,
                  ),
                ),
                const Text(
                  "未更正",
                  style: TextStyle(
                    // backgroundColor: Colors.yellow,
                    fontSize: 17.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap8,
          Container(
            width: _screenUtil.screenWidth - 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 10.0,
            ),
            child: const Text(
              "你还未更正读音喔~",
              style: TextStyle(
                fontSize: 14.0,
                color: Colours.color_999999,
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
      // navigationBar: const XTCupertinoNavigationBar(
      //   backgroundColor: Color(0xFFFFFFFF),
      //   border: null,
      //   padding: EdgeInsetsDirectional.zero,
      //   leading: NavigationBackWidget(),
      //   middle: Text(
      //     "纠错",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      child: Scaffold(
          body: CustomPaint(
        painter: TopOriginPainter(),
        size: Size.infinite,
        child: Stack(
          children: [
            MyScrollView(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const XTCupertinoNavigationBar(
                  backgroundColor: Color(0xFFFFFFFF),
                  border: null,
                  padding: EdgeInsetsDirectional.zero,
                  leading: NavigationBackWidget(),
                  middle: Text(
                    "纠错",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // const Center(
                //   child: Text(
                //     "Unit2 朋友见面",
                //     style: TextStyle(
                //       fontSize: 17.0,
                //       fontWeight: FontWeight.w400,
                //       color: Colors.black,
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Expanded(child: Text("data")),
                    const Text(
                      "2/3",
                      style: TextStyle(
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Gaps.hGap26
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colours.color_F9F8FF,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18.0,
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const LoadAssetImage(
                            'default_head_img',
                            width: 25.0,
                            height: 25.0,
                          ),
                          Gaps.hGap6,
                          const Text(
                            "lisu",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Really? Awesome， Awesome，Behind me are the Alps，Now I'm going skiing，shall we go？",
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colours.color_666666,
                        ),
                      ),
                      const ErrorCorrectionDetailItem(),
                      const ErrorCorrectionOneDetailItem(),
                      notReachItem(),
                      // const ErrorCorrectionThreeDetailItem(),
                      BottomErrorBar(
                        chatWebsocket: _chatWebsocket,
                        controller: _bottomBarControll,
                        recordController: _recordController,
                        onScrollEnd: () {},
                      )
                    ],
                  ),
                ),
                Gaps.vGap10,
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
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              child: ValueListenableBuilder(
                valueListenable: _bottomBarControll.showRecord,
                builder: (_, show, __) =>
                    Record(show: show, controller: _recordController),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class TopOriginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 定义新的坐标系原点
    canvas.translate(0.0, size.height);
    // 绘制操作从这里开始
    // ...
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
