import 'package:Bubble/exam/exam_router.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/dash_line.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MockExaminationOnePage extends StatefulWidget {
  const MockExaminationOnePage({super.key});

  @override
  State<MockExaminationOnePage> createState() => _MockExaminationOnePageState();
}

class _MockExaminationOnePageState extends State<MockExaminationOnePage> {
  Widget numberWidget = const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        "1",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      ),
      SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Text(
        "2",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      ),
      SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Text(
        "3",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      ),
      SizedBox(
        width: 12,
        child: DashLine(
          width: 1,
          direction: Axis.horizontal,
          color: Colors.black,
        ),
      ),
      Text(
        "4",
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
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
              Expanded(
                child: Column(
                  children: [
                    Gaps.vGap60,
                    Row(
                      children: [
                        const NavigationBackWidget(),
                        numberWidget,
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigatorUtils.push(
                          context,
                          replace: true,
                          ExamRouter.mockExaminationendTwoPage,
                        );
                      },
                      child: const Text(
                        "下一步",
                        style: TextStyle(
                            color: Colours.color_0047FF,
                            fontSize: 20,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const Expanded(child: Gaps.empty),
                    Container(
                        padding: const EdgeInsets.all(25),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.black.withOpacity(0.85),
                        ),
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
                              "您好，秋子，我是Andy老师，现在向你介绍KET口语考试流程与注意事项",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                            Gaps.vGap10,
                          ],
                        )),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
