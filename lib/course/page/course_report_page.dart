//课程报告
import 'dart:math';

import 'package:Bubble/course/entity/lesson_report_detail_bean.dart';
import 'package:Bubble/course/item/course_report_select_item.dart';
import 'package:Bubble/course/item/course_report_vocabulary_item.dart';
import 'package:Bubble/course/item/course_report_vocabulary_two_item.dart';
import 'package:Bubble/course/item/play_back_item.dart';
import 'package:Bubble/course/presenter/course_report_page_presenter.dart';
import 'package:Bubble/course/view/course_report_page_view.dart';
import 'package:Bubble/loginManager/login_manager.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/item/error_correction_detail_item.dart';
import 'package:Bubble/person/item/error_correction_item.dart';
import 'package:Bubble/report/widget/radar.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/circle_progress_view.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/star_rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseReportPage extends StatefulWidget {
  final String lessonId;
  const CourseReportPage({super.key, required this.lessonId});

  @override
  State<CourseReportPage> createState() => _CourseReportPageState();
}

class _CourseReportPageState extends State<CourseReportPage>
    with
        BasePageMixin<CourseReportPage, CourseReportPagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<CourseReportPage>
    implements CourseReportPageView {
  final ScreenUtil _screenUtil = ScreenUtil();
  late CourseReportPagePresenter _courseReportPagePresenter;
  bool isLoding = true;
  late LessonReportDetailBean lessonReportDetailData;
  late String userName = "";
  late String headimgurl = "";
  double star = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseReportPagePresenter.getStepDetail(widget.lessonId);
    Map<String, dynamic> user = LoginManager.getUserInfo();

    String name = '';
    if (validateInput(user['name']) && user['name'] != '微信用户') {
      name = user['name'];
    } else if (validateInput(user['nickname'])) {
      name = user['nickname'];
    } else {
      String phone = '';
      if (validateInput(user['phone'])) {
        phone = user['phone'];
        name = "用户${phone.toString().substring(7, 11)}";
      }
    }
    userName = name;

    String headImg = '';
    if (validateInput(user['headimgurl'])) {
      headImg = user['headimgurl'];
    }
    headimgurl = headImg;
  }

  bool validateInput(String? input) {
    if (input == null) {
      return false;
    }

    if (input.isEmpty) {
      return false;
    }

    return true;
  }

  Widget headWidget(
    String imgStr,
  ) {
    return SliverToBoxAdapter(
      child: Container(
        height: 80,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadAssetImage(
              imgStr,
              height: 50,
              // width: 45.0,
              // height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPatternItems() {
    List<Widget> list = [];
    for (int i = 0;
        i < lessonReportDetailData.data.objectives.sentencePattern.length;
        i++) {
      list.add(PlayBackItem(
          title: lessonReportDetailData
              .data.objectives.sentencePattern[i].sentence,
          isPaly: true));
    }
    return list;
  }

  List<Widget> _buildSkillsItems() {
    List<Widget> list = [];
    for (int i = 0;
        i < lessonReportDetailData.data.objectives.speakingSkills.length;
        i++) {
      list.add(PlayBackItem(
          title: lessonReportDetailData.data.objectives.speakingSkills[i].skill,
          isPaly: true));
    }
    return list;
  }

  Widget radar() {
    return Container(
      height: 240.0,
      color: Colors.white,
      child: Container(
          width: _screenUtil.screenWidth,
          height: 240.0,
          margin: const EdgeInsets.only(left: 16, right: 16),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/radar_bg.png',
              ),
              fit: BoxFit.fitWidth,
            ),
          ),
          alignment: Alignment.center,
          child: Radar(
            r: sqrt(5000),
            top: RadarItem('流畅度', lessonReportDetailData.data.fluencyScore),
            bottom:
                RadarItem('完整度', lessonReportDetailData.data.integrityScore),
            left: RadarItem('发音', lessonReportDetailData.data.standardScore),
            right: RadarItem('语法', lessonReportDetailData.data.accuracyScore),
            scoreStyle: const TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 25.7 / 22.0,
            ),
            labelStyle: const TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
              height: 14.0 / 12.0,
            ),
          )),
    );
  }

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      child: Scaffold(
          body: isLoding
              ? lodingView()
              : CustomPaint(
                  painter: TopOriginPainter(),
                  size: Size.infinite,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/person_bg.png',
                        ),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    child: CustomScrollView(
                      slivers: [
                        SliverPersistentHeader(
                            pinned: true,
                            delegate: _SliverAppBarDelegate(
                                minHeight: 120,
                                maxHeight: 120,
                                child: const XTCupertinoNavigationBar(
                                  backgroundColor: Color.fromRGBO(1, 1, 1, 0),
                                  border: null,
                                  padding: EdgeInsetsDirectional.zero,
                                  leading: NavigationBackWidget(),
                                  middle: Text(
                                    "口语嘟嘟 学习报告",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ))),

                        SliverToBoxAdapter(
                          child: Stack(
                            children: [
                              Container(
                                width: _screenUtil.screenWidth,
                                padding: const EdgeInsets.only(top: 40),
                                margin: const EdgeInsets.only(top: 30),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white70,
                                      Colors.white,
                                      Colors.white,
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Gaps.vGap6,
                                    RatingBar(
                                      initialRating: star,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 20,
                                      ignoreGestures: true,
                                      ratingWidget: RatingWidget(
                                        full: const LoadAssetImage(
                                            'full_star_img'),
                                        half: const LoadAssetImage(
                                            'full_star_img'),
                                        empty: const LoadAssetImage(
                                            'empty_star_img'),
                                      ),
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 2.0),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Gaps.vGap6,
                                    Text(
                                      "${lessonReportDetailData.data.levelName}  ${lessonReportDetailData.data.unitName}",
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colours.color_666666,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Gaps.vGap4,
                                    Text(
                                      lessonReportDetailData.data.lessonName,
                                      style: const TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(30.0),
                                    child: LoadImage(
                                      headimgurl,
                                      width: 60.0,
                                      height: 60.0,
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: _screenUtil.screenWidth / 2 - 20,
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                        left: 16, right: 4, top: 12, bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colours.color_FAF3FF,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const LoadAssetImage(
                                          "report_zan_icon",
                                          width: 48.0,
                                          height: 48.0,
                                        ),
                                        Gaps.vGap10,
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: lessonReportDetailData
                                                    .data.goodCount
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colours.color_333333,
                                                )),
                                            const TextSpan(
                                                text: '个赞',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colours.color_333333,
                                                )),
                                          ]),
                                        ),
                                        Gaps.vGap4,
                                        Text(
                                          "超过${lessonReportDetailData.data.goodRank}的同学",
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colours.color_906DA9,
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                    width: _screenUtil.screenWidth / 2 - 20,
                                    height: 150,
                                    margin: const EdgeInsets.only(
                                        left: 4, right: 16, top: 12, bottom: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Colours.color_EFF9FF,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const LoadAssetImage(
                                          "report_sentence_icon",
                                          width: 48.0,
                                          height: 48.0,
                                        ),
                                        Gaps.vGap10,
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(
                                                text: lessonReportDetailData
                                                    .data.sentenceCount
                                                    .toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colours.color_333333,
                                                )),
                                            const TextSpan(
                                                text: '次开口',
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colours.color_333333,
                                                )),
                                          ]),
                                        ),
                                        Gaps.vGap4,
                                        Text(
                                          "超过${lessonReportDetailData.data.sentenceRank}的同学",
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colours.color_3770C6,
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: radar(),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 80,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Gaps.vGap16,
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadAssetImage(
                                      "youxiubiaoda",
                                      height: 55,
                                      // width: 45.0,
                                      // height: 50.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // headWidget("youxiubiaoda"),
                        SliverList.builder(
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {},
                              child: ErrorCorrectionDetailTwoItem(
                                  excellentExpression: lessonReportDetailData
                                      .data.excellentExpression[index]),
                            );
                          },
                          itemCount: lessonReportDetailData
                              .data.excellentExpression.length,
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            height: 80,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Gaps.vGap16,
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    LoadAssetImage(
                                      "benkeshouhuo",
                                      height: 56,
                                      // width: 45.0,
                                      // height: 50.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // headWidget("benkeshouhuo"),
                        SliverToBoxAdapter(
                          child: CourseReportVocabularyTwoItem(
                              vocabulary: lessonReportDetailData
                                  .data.objectives.vocabulary),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colours.color_F9F8FF,
                              ),
                              // color: Colors.red,
                              child: Column(
                                children: [
                                  Gaps.vGap8,
                                  Row(
                                    children: [
                                      Gaps.hGap12,
                                      const LoadAssetImage(
                                        "head_juxing_icon",
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                      Gaps.hGap8,
                                      RichText(
                                        text: const TextSpan(children: [
                                          TextSpan(
                                              text: "句型  ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                          TextSpan(
                                              text: "Sentence pattern",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                        ]),
                                      ),
                                    ],
                                  ),
                                  Gaps.vGap11,
                                  Column(
                                    children: _buildPatternItems(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // headWidget("Speak Skill", "12"),

                        SliverToBoxAdapter(
                          child: Container(
                            color: Colors.white,
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colours.color_F9F8FF,
                              ),
                              // color: Colors.red,
                              child: Column(
                                children: [
                                  Gaps.vGap8,
                                  Row(
                                    children: [
                                      Gaps.hGap8,
                                      const LoadAssetImage(
                                        "head_nengli_icon",
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                      Gaps.hGap8,
                                      RichText(
                                        text: const TextSpan(children: [
                                          TextSpan(
                                              text: "能力  ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                          TextSpan(
                                              text: "Speaking Skills",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black,
                                              )),
                                        ]),
                                      ),
                                    ],
                                  ),
                                  Gaps.vGap11,
                                  Column(
                                    children: _buildSkillsItems(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Gaps.vGap30,
                        ),
                      ],
                    ),
                  ))),
    );
  }

  @override
  CourseReportPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _courseReportPagePresenter = CourseReportPagePresenter();
    return _courseReportPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(LessonReportDetailBean data) {
    // TODO: implement sendSuccess
    setState(() {
      isLoding = false;
      lessonReportDetailData = data;
      if (lessonReportDetailData.data.totalScore >= 91) {
        star = 5;
      } else if (lessonReportDetailData.data.totalScore >= 80 &&
          lessonReportDetailData.data.totalScore < 91) {
        star = 4;
      } else if (lessonReportDetailData.data.totalScore >= 60 &&
          lessonReportDetailData.data.totalScore < 80) {
        star = 3;
      } else if (lessonReportDetailData.data.totalScore >= 50 &&
          lessonReportDetailData.data.totalScore < 60) {
        star = 2;
      } else {
        star = 1;
      }
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
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
