import 'package:Bubble/exam/entity/exam_detail_bean.dart';
import 'package:Bubble/exam/exam_purchase.dart';
import 'package:Bubble/exam/presenter/exam_detail_page_presenter.dart';
import 'package:Bubble/exam/view/bar_chart.dart';
import 'package:Bubble/exam/view/exam_detail_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../loginManager/login_manager.dart';

class MockExaminationendTwoPage extends StatefulWidget {
  final String mockId;

  const MockExaminationendTwoPage({super.key, required this.mockId});

  @override
  State<MockExaminationendTwoPage> createState() =>
      _MockExaminationendTwoPageState();
}

class _MockExaminationendTwoPageState extends State<MockExaminationendTwoPage>
    with
        BasePageMixin<MockExaminationendTwoPage, ExamDetailPagePresenter>,
        AutomaticKeepAliveClientMixin<MockExaminationendTwoPage>
    implements ExamDetailView {
  late ExamDetailPagePresenter _examDetailPagePresenter;
  late ExamDetailBean _examDetailBean;
  late bool isloading = true;
  late List<double> _peopleData;
  late String name = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(microseconds: 200), () {
      _examDetailPagePresenter.getExamDetail(widget.mockId);
    });
    _peopleData = [
      100,
      75,
      45,
      25,
    ];
    Map<String, dynamic> user = LoginManager.getUserInfo();
    name = user['name'] == ""
        ? (user['nickname'] == ""
            ? '用户${user['phone'].toString().substring(7, 11)}'
            : user['nickname'])
        : user['name'];
  }

  Widget score() {
    return Container(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _examDetailBean.data.totalScore.toString(),
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 37.5 / 32.0,
                  ),
                ),
                const Text(
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
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _examDetailBean.data.ket,
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    "Grade",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      height: 3.0,
                    ),
                  ),
                ],
              ),
              const Text(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _examDetailBean.data.camb.toString(),
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              const Text(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _examDetailBean.data.europe,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
              ),
              const Text(
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
                Text(
                  "$name, your ket oral mock exam is over. Let's sum it up together.",
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                Gaps.vGap8,
                Text(
                  "$name，你的KET口语模拟考试结束了，我们一起总结一下吧。",
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Gaps.vGap8,
          score(),
          Gaps.vGap8,
          typeWidget(context),
          Gaps.vGap10,
          BarChart(xData, _peopleData, colorData),
          Gaps.vGap8,
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colours.color_CDEDF4,
              ),
              child: Column(
                children: [
                  Text(
                    "您的成绩还不错，口语模考达到了剑桥KET考试的Grade ${_examDetailBean.data.ket}水平。",
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.black,
                    ),
                  ),
                  Gaps.vGap8,
                  RichText(
                      // RichText
                      text: TextSpan(
                          text: '建议考前再练习',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                          ),
                          children: <TextSpan>[
                        TextSpan(
                            text: _examDetailBean.data.trainCount.toString(),
                            style: const TextStyle(
                              color: Colours.color_FF00A8,
                              fontSize: 20.0,
                            )),
                        TextSpan(
                            text:
                                '次模拟考试，争取达到Grade ${_examDetailBean.data.ketNext}水平，加油宝贝！',
                            style: const TextStyle(fontSize: 15)),
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
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.transparent,
                  isScrollControlled: true,
                  isDismissible: false,
                  enableDrag: false,
                  builder: (_) => ExamPurchasePage(
                    onPurchased: () {},
                  ),
                );
              },
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "如需查看详细模拟考试报告，可通过【个人中心-学习报告-模考报告】进行查阅。",
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
              ),
              Gaps.vGap8,
              const Text(
                "今天的模考就到这里，期待下次模考见！",
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
          Expanded(
              child: SingleChildScrollView(
                  child: isloading ? const Center() : body())),
        ]),
      ),
    );
  }

  @override
  ExamDetailPagePresenter createPresenter() {
    _examDetailPagePresenter = ExamDetailPagePresenter();
    return _examDetailPagePresenter;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(ExamDetailBean examDetailBean) {
    // TODO: implement sendSuccess
    setState(() {
      isloading = false;
      _examDetailBean = examDetailBean;
      _peopleData = [
        _examDetailBean.data.accuracyScore.toDouble(),
        _examDetailBean.data.standardScore.toDouble(),
        _examDetailBean.data.interactionScore.toDouble(),
        _examDetailBean.data.overallScore.toDouble(),
      ];
    });
  }
}
