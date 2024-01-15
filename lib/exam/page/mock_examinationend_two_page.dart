import 'package:Bubble/exam/view/bar_chart.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MockExaminationendTwoPage extends StatefulWidget {
  const MockExaminationendTwoPage({super.key});

  @override
  State<MockExaminationendTwoPage> createState() =>
      _MockExaminationendTwoPageState();
}

class _MockExaminationendTwoPageState extends State<MockExaminationendTwoPage> {
  Widget score = Container(
    // width: width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20.0),
      color: Colors.black.withOpacity(0.85),
    ),
    padding: const EdgeInsets.symmetric(
      vertical: 48.0,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colours.color_51D6FF,
                  ),
                  width: 8,
                  height: 8,
                ),
                Gaps.hGap6,
                const Text(
                  '5发音',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Gaps.vGap2,
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colours.color_FF71CF,
                  ),
                  width: 8,
                  height: 8,
                ),
                Gaps.hGap6,
                const Text(
                  '5互动',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Gaps.vGap2,
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colours.color_E8CCFE,
                  ),
                  width: 8,
                  height: 8,
                ),
                Gaps.hGap6,
                const Text(
                  '4语法词汇',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Gaps.vGap2,
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colours.color_8E30FF,
                  ),
                  width: 8,
                  height: 8,
                ),
                Gaps.hGap6,
                const Text(
                  '4整体得分',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        Gaps.hGap16,
        const SizedBox(
          width: 20.0,
        ),
        Container(
          width: 128.0,
          height: 128.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/caihuan.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${76}',
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 37.5 / 32.0,
                ),
              ),
              Text(
                '  总分',
                style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  height: 14.0 / 12.0,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget typeWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ((MediaQuery.of(context).size.width - 32.0) / 3 - 5) / 2),
            color: Colours.color_E8CCFE,
          ),
          width: (MediaQuery.of(context).size.width - 32.0) / 3 - 5,
          height: (MediaQuery.of(context).size.width - 32.0) / 3 - 5,
          // color: Colours.color_E8CCFE,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "B",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Grade",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 2.5,
                      // letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
              Text(
                "KET证书等级",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Gaps.hGap5,
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ((MediaQuery.of(context).size.width - 32.0) / 3 - 5) / 2),
            color: Colours.color_C1EBF7,
          ),
          width: (MediaQuery.of(context).size.width - 32.0) / 3 - 5,
          height: (MediaQuery.of(context).size.width - 32.0) / 3 - 5,
          // color: Colours.color_E8CCFE,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "121",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Text(
                "剑桥考试成绩",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Gaps.hGap5,
        Container(
          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                ((MediaQuery.of(context).size.width - 32.0) / 3 - 5) / 2),
            color: Colours.color_DDF3D2,
          ),
          width: (MediaQuery.of(context).size.width - 32.0) / 3 - 5,
          height: (MediaQuery.of(context).size.width - 32.0) / 3 - 5,
          // color: Colours.color_E8CCFE,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "A2",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              Text(
                "欧洲语言共同参考标准",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> xData = [
    "语法与词汇",
    "发音",
    "互动",
    "整体得分",
  ];
  List<double> peopleData = [
    100,
    75,
    45,
    25,
  ];
  List<Color> colorData = [
    Colours.color_51D8FF,
    Colours.color_FF71CF,
    Colours.color_8E30FF,
    Colours.color_E8CCFE,
  ];

  Widget contentBar() {
    return Container(
      width: double.infinity,
      // height: double.infinity,
      // color: Colors.white,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Gaps.vGap8,
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colours.color_F4F4F4,
            ),
            // color: Colours.color_F4F4F4,
            child: Column(
              children: [
                const Text(
                  "Qiu Zi, your ket oral mock exam is over. Let's sum it up together.",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                Gaps.vGap8,
                const Text(
                  "秋子，你的KET口语模拟考试结束了，我们一起总结一下吧。",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap8,
          score,
          Gaps.vGap8,
          typeWidget(context),
          Gaps.vGap10,
          BarChart(xData, peopleData, colorData),
          Gaps.vGap8,
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colours.color_CDEDF4,
              ),
              child: Column(
                children: [
                  const Text(
                    "您的成绩还不错，口语模考达到了剑桥KET考试的Grade B水平。",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  Gaps.vGap8,
                  RichText(
                      // RichText
                      text: const TextSpan(
                          text: '建议考前再练习',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                            text: '10',
                            style: TextStyle(
                              color: Colours.color_FF00A8,
                              fontSize: 20.0,
                            )),
                        TextSpan(
                            text: '次模拟考试，争取达到Grade B+水平，加油宝贝！',
                            style: TextStyle(fontSize: 15)),
                      ])),
                ],
              )),
          Gaps.vGap8,
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        contentBar(),
        Gaps.vGap10,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: Container(
                width: 231.0,
                height: 48.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  border: Border.all(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: Colours.color_001652,
                  ),
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
                  '点击购买模考训练包',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Colours.color_001652,
                  ),
                ),
              ),
            ),
          ],
        ),
        Gaps.vGap15,
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colours.color_F4F4F4,
          ),
          // color: Colours.color_F4F4F4,
          child: Column(
            children: [
              const Text(
                "Qiu Zi, your ket oral mock exam is over. Let's sum it up together.",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              Gaps.vGap8,
              const Text(
                "秋子，你的KET口语模拟考试结束了，我们一起总结一下吧。",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Gaps.vGap20,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil screenUtil = ScreenUtil();

    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(children: [
          XTCupertinoNavigationBar(
              backgroundColor: Color(0xFFFFFFFF),
              border: null,
              padding: EdgeInsetsDirectional.zero,
              leading: NavigationBackWidget(),
              middle: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadAssetImage(
                    'zhuangshi_zuo',
                    width: 16.0,
                    height: 16.0,
                  ),
                  Gaps.hGap6,
                  const Text(
                    '模考报告',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                  Gaps.hGap6,
                  const LoadAssetImage(
                    'zhuangshi_you',
                    width: 16.0,
                    height: 16.0,
                  ),
                ],
              ),
              trailing: const SizedBox(
                width: 45,
              )),
          // Gaps.vGap10,
          Expanded(child: SingleChildScrollView(child: body())),
        ]),
      ),
    );
  }
}
