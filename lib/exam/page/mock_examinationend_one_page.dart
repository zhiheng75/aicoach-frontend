import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/res/resources.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/image_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/dash_line.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Bubble/widgets/my_alert.dart';

class MockExaminationendOnePage extends StatefulWidget {
  final String mockId;

  const MockExaminationendOnePage({super.key, required this.mockId});

  @override
  State<MockExaminationendOnePage> createState() =>
      _MockExaminationendOnePageState();
}

class _MockExaminationendOnePageState extends State<MockExaminationendOnePage> {
  late BuildContext bcontext;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  Widget numberWidget = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_n_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "1",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_n_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "2",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_n_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "3",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
      const SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/number_s_icon.png',
            ),
            fit: BoxFit.fitHeight,
          ),
        ),
        child: const Center(
          child: Text(
            "4",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    ],
  );

  ///返回事件
  void onBack() {
    myAlert.showAlert(bcontext,
        title: "离开考场",
        content: "模拟考试进行中,\n请尽可能一次性完成整场模拟考试", clickCallback: (index, text) {
      if (index == 1) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bcontext = context;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              const LoadImage(
                "_headerImg",
                holderImg: "splash_bg",
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Column(
                children: [
                  Gaps.vGap50,
                  Row(
                    children: [
                      NavigationBackWidget(onBack: onBack),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 100,
                      ),
                      numberWidget,
                      // GestureDetector(
                      //   onTap: () {
                      //     // NavigatorUtils.push(
                      //     //   context,
                      //     //   ExamRouter.mockExaminationTwoPage,
                      //     // );
                      //   },
                      //   child: const Text(
                      //     "提交",
                      //     style: TextStyle(
                      //         color: Colours.color_0047FF,
                      //         fontSize: 20,
                      //         decoration: TextDecoration.underline),
                      //   ),
                      // ),
                    ],
                  ),

                  Gaps.vGap168,
                  // const Expanded(child: Gaps.empty),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black.withOpacity(0.85),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Text(
                                "Hello, Qiu Zi, I'm Teacher Andy. Now I'd like to introduce you to the KET oral exam process and matters needing attention.",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colours.color_FFF5BF,
                                ),
                              ),
                              Gaps.vGap8,
                              const Text(
                                "您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项",
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.vGap10,
                            ],
                          ),
                        )),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
