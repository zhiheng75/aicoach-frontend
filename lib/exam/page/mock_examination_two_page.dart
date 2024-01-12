import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/dash_line.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockExaminationTwoPage extends StatefulWidget {
  const MockExaminationTwoPage({super.key});

  @override
  State<MockExaminationTwoPage> createState() => _MockExaminationTwoPageState();
}

class _MockExaminationTwoPageState extends State<MockExaminationTwoPage> {
  String type = "2";

  ///启动倒计时器
  // void _startTimer() {
  //   _seconds = 10;
  //   // canResend = false;
  //   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
  //     Log.e(":111111111");
  //     _seconds = _seconds! - 1;

  //     if (_seconds == 0) {
  //       _timer?.cancel();
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _startTimer();
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      // DeviceOrientation.landscapeRight
    ]);
  }

  @override
  void dispose() {
    // 强制横屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement dispose
    super.dispose();
  }

  Widget peopleWidget(bool isVector, String name) {
    return Stack(
      children: [
        const LoadAssetImage(
          'personal_center_bg',
          width: 140, height: 100,
          // fit: BoxFit.cover
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                isVector
                    ? Image.asset(
                        'assets/images/shengbo.gif',
                        width: 35,
                        height: 18,
                        fit: BoxFit.fitWidth,
                      )
                    : Container(),
                Text(name,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    )),
              ],
            ))
      ],
    );

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.black,
            image: DecorationImage(
                image: ImageUtils.getAssetImage("mkbg"), fit: BoxFit.fill)),
        width: 140,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isVector
                ? Image.asset(
                    'assets/images/shengbo.gif',
                    width: 35,
                    height: 18,
                    fit: BoxFit.fitWidth,
                  )
                : Container(),
            Text(name,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )),
          ],
        ));
  }

  //说话的框
  showConfirmDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              // Navigator.pop(context);
            },
            child: const Center(
              child: LoadAssetImage(
                'shengbo_pink',
                width: 147,
                height: 56,
              ),
            ),
          );
        });
  }

  showImageDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 480,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const LoadAssetImage(
                      'reminder_close',
                      width: 32,
                      height: 32,
                    ),
                  ),
                ],
              ),
              Gaps.vGap8,
              Stack(
                children: [
                  const Center(
                    child: LoadAssetImage(
                      'personal_center_bg',
                      width: 512, height: 288,
                      // fit: BoxFit.cover
                    ),
                  ),
                  Positioned(
                      // top: 0,
                      // right: 0,
                      // left: 0,
                      // height: 32,
                      // width: 512,
                      child: Center(
                    child: Container(
                      width: 512,
                      height: 32,
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(10),
                      //   color: Colors.white,
                      // ),
                      child: const Center(
                        child: Text(
                          "KET模拟考试 Part2 看图对话",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                              decoration: TextDecoration.none),
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ImageUtils.getAssetImage("splash_bg"),
                      fit: BoxFit.fill)),
              child: Expanded(
                child: Column(
                  children: [
                    const XTCupertinoNavigationBar(
                      backgroundColor: Color(0xFFFFFFFF),
                      border: null,
                      padding: EdgeInsetsDirectional.zero,
                      leading: NavigationBackWidget(),
                      middle: Text(
                        "KET考试模拟现场",
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              Text("1"),
                              SizedBox(
                                width: 12,
                                child: DashLine(
                                  width: 1,
                                  direction: Axis.horizontal,
                                  color: Colors.black,
                                ),
                              ),
                              Text("2"),
                              SizedBox(
                                width: 12,
                                child: DashLine(
                                  width: 1,
                                  direction: Axis.horizontal,
                                  color: Colors.black,
                                ),
                              ),
                              Text("3"),
                              SizedBox(
                                width: 12,
                                child: DashLine(
                                  width: 1,
                                  direction: Axis.horizontal,
                                  color: Colors.black,
                                ),
                              ),
                              Text("4"),
                            ],
                          )),
                    ),
                    Gaps.vGap10,
                    Expanded(
                      child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              // color: Colors.white,
                              width: 188,
                              height: double.infinity,
                              // margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Gaps.vGap20,
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.color_E8CCFE,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 8,
                                          bottom: 8),
                                      child: const Text(
                                        "考官",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Gaps.vGap10,
                                  peopleWidget(true, "口语考官：Andy老师"),
                                  Gaps.vGap10,
                                  peopleWidget(true, "计分考官：Andy老师"),
                                ],
                              ),
                            ),
                            Gaps.hGap5,
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image:
                                          ImageUtils.getAssetImage("splash_bg"),
                                      fit: BoxFit.fill)),
                              width: MediaQuery.of(context).size.width -
                                  188 * 2 -
                                  6.w * 2,
                              // width: double.infinity,

                              height: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Gaps.vGap10,
                                  type == "1"
                                      ? const Text("请你提问一个问题")
                                      : Center(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.white),
                                                child: const Text(
                                                  " 倒计时: 20s ",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Gaps.vGap10,
                                              GestureDetector(
                                                onTap: () {},
                                                child: const LoadAssetImage(
                                                  'jpgicon',
                                                  width: 82,
                                                  height: 100,
                                                ),
                                              ),
                                              Gaps.vGap10,
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20,
                                                    right: 20,
                                                    top: 10,
                                                    bottom: 10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    color: Colors.black),
                                                child: const Text(
                                                  "图片接收成功，可以点击查看大图",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  const Expanded(child: Gaps.empty),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        //点击答题
                                        // showConfirmDialog();
                                        // showImageDialog();

                                        NavigatorUtils.push(
                                          context,
                                          replace: true,
                                          ExamRouter.mockExaminationendOnePage,
                                        );
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: Colours.color_examination,
                                          ),
                                          width: 207,
                                          height: 48,
                                          // color: Colours.color_examination,
                                          child: const Center(
                                            child: Text(
                                              "长按答题",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )),
                                    ),
                                  ),
                                  // Gaps.vGap20,
                                ],
                              ),
                            ),
                            Gaps.hGap5,
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              // color: Colors.white,
                              width: 188,
                              height: double.infinity,
                              child: Column(
                                children: [
                                  Gaps.vGap20,
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colours.color_C1EBF7,
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 12,
                                          right: 12,
                                          top: 8,
                                          bottom: 8),
                                      child: const Text(
                                        "学生",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )),
                                  Gaps.vGap10,
                                  peopleWidget(true, "口语考官：Andy老师"),
                                  Gaps.vGap10,
                                  peopleWidget(true, "计分考官：Andy老师"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
