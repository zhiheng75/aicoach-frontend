import 'dart:math';

import 'package:Bubble/exam/entity/exam_detail_bean.dart';
import 'package:Bubble/exam/presenter/exam_detail_page_presenter.dart';
import 'package:Bubble/exam/view/bar_chart.dart';
import 'package:Bubble/exam/view/exam_detail_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/report/page/my_examination_detail_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/services.dart';

class MyExaminationPage extends StatefulWidget {
  final String mockId;

  const MyExaminationPage({super.key, required this.mockId});

  @override
  State<MyExaminationPage> createState() => _MyExaminationPageState();
}

class _MyExaminationPageState extends State<MyExaminationPage>
    with
        TickerProviderStateMixin,
        BasePageMixin<MyExaminationPage, ExamDetailPagePresenter>,
        AutomaticKeepAliveClientMixin<MyExaminationPage>
    implements ExamDetailView {
  // ///当前选择tab索引
  int curTabIndex = 0;
  // String tabType = 'evaluation';

  // late final TabController primaryTC;
  // late final TabController secondaryTC;

  late ExamDetailPagePresenter _examDetailPagePresenter;
  late ExamDetailBean _examDetailBean;
  late bool isloading = true;
  late List<double> _peopleData;

  @override
  void initState() {
    super.initState();
    // primaryTC = TabController(length: 2, vsync: this);
    // secondaryTC = TabController(length: 5, vsync: this);
    Future.delayed(const Duration(microseconds: 200), () {
      _examDetailPagePresenter.getExamDetail(widget.mockId);
    });
    _peopleData = [
      100,
      75,
      45,
      25,
    ];
  }

  @override
  void dispose() {
    // primaryTC.dispose();
    // secondaryTC.dispose();
    super.dispose();
  }

  Widget barItem(String label, bool isSelected, int idx) {
    // bool isSelected = tabType == type;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (isSelected) {
          return;
        }
        setState(() {
          curTabIndex = idx;
        });
        // tapTabbar(type);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xFF000000)
                  : const Color(0xFF333333),
              height: 18.0 / 16.0,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            width: 56.0,
            height: 3.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              gradient: isSelected
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colours.color_9AC3FF,
                        Colours.color_FF71E0,
                      ],
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget tabbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        barItem('综合评价', curTabIndex == 0 ? true : false, 0),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: barItem('地道表达建议', curTabIndex == 1 ? true : false, 1),
        ),
        barItem('细节解析', curTabIndex == 2 ? true : false, 2),
      ],
    );
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
              Text(
                _examDetailBean.data.ket,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                ),
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
  // List<double> peopleData = [
  //   100,
  //   75,
  //   45,
  //   25,
  // ];
  List<Color> colorData = [
    Colours.color_51D8FF,
    Colours.color_FF71CF,
    Colours.color_8E30FF,
    Colours.color_E8CCFE,
  ];

  Widget archiveTopWidget(BuildContext context) {
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
          Text(
            "开始时间:${_examDetailBean.data.createTime} 考试时长:${_examDetailBean.data.duration / 60}分钟",
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
            child: extended.ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // return buildSliverHeader();
            return [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                expandedHeight: 52,
                backgroundColor: Colors.white,
                flexibleSpace: Center(
                  child: Row(
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
                ),
                leading: const NavigationBackWidget(),
              ),
              SliverToBoxAdapter(
                child: archiveTopWidget(context),
              ),
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 45, //收起的高度
                    maxHeight: 45,
                    child: Container(color: Colors.white, child: tabbar()),
                  ))
            ];
          },
          // pinnedHeaderSliverHeightBuilder: () {
          //   return 100;
          // },
          body: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: curTabIndex,
                  children: const [
                    //                 extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    //   Key('Tab0'),
                    //   MyReceivePage(),
                    // ),
                    extended.ExtendedVisibilityDetector(
                      uniqueKey: Key('Tab0'),
                      child: MyExaminationDetailPage(
                        idStr: 'Tab0',
                      ),
                    ),
                    extended.ExtendedVisibilityDetector(
                      uniqueKey: Key('Tab1'),
                      child: MyExaminationDetailPage(
                        idStr: 'Tab1',
                      ),
                    ),
                    extended.ExtendedVisibilityDetector(
                      uniqueKey: Key('Tab2'),
                      child: MyExaminationDetailPage(
                        idStr: 'Tab2',
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
