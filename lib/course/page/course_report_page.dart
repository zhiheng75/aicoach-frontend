//课程报告
import 'dart:math';

import 'package:Bubble/course/item/course_report_select_item.dart';
import 'package:Bubble/course/item/course_report_vocabulary_item.dart';
import 'package:Bubble/course/item/play_back_item.dart';
import 'package:Bubble/person/item/error_correction_detail_item.dart';
import 'package:Bubble/person/item/error_correction_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/circle_progress_view.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:Bubble/widgets/star_rating.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourseReportPage extends StatefulWidget {
  const CourseReportPage({super.key});

  @override
  State<CourseReportPage> createState() => _CourseReportPageState();
}

class _CourseReportPageState extends State<CourseReportPage> {
  final ScreenUtil _screenUtil = ScreenUtil();

  Widget headWidget(String headStr, String numberStr) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Gaps.hGap16,
            const LoadAssetImage(
              "home_head_icon",
              width: 40.0,
              height: 40.0,
            ),
            Gaps.hGap8,
            RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: headStr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    )),
                TextSpan(
                    text: numberStr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_FF71CF,
                    )),
                const TextSpan(
                    text: "个",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_666666,
                    )),
              ]),
            ),
          ],
        ),
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
      //     "课程报告",
      //     style: TextStyle(fontWeight: FontWeight.bold),
      //   ),
      // ),
      child: Scaffold(
          body: CustomPaint(
              painter: TopOriginPainter(),
              size: Size.infinite,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/images/splash_bg.png',
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
                                "Bubble AI 学习报告",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ))),
                    // const SliverToBoxAdapter(
                    //   child: SizedBox(
                    //     height: 120,
                    //   ),
                    // ),
                    SliverToBoxAdapter(
                      child: Stack(
                        children: [
                          Container(
                            width: 1000,
                            padding: const EdgeInsets.only(top: 40),
                            margin: const EdgeInsets.only(top: 30),
                            color: Colors.white,
                            child: Column(
                              children: [
                                const Text(
                                  "欧阳小明",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                                StarRating(rating: 3.4, isShowLeftText: false),
                                const Text(
                                  "L3系统班 Unit1",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                    color: Colours.color_666666,
                                  ),
                                ),
                                const Text(
                                  "Lesson1 认识农场里的动物",
                                  style: TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              // top: 0,
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: const LoadImage(
                                  "headimgurl",
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
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colours.color_FAF3FF,
                                ),
                                // padding: const EdgeInsets.symmetric(
                                //   horizontal: 35.0,
                                //   vertical: 15.0,
                                // ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const LoadAssetImage(
                                      "report_zan_icon",
                                      width: 48.0,
                                      height: 48.0,
                                    ),
                                    Gaps.vGap10,
                                    RichText(
                                      text: const TextSpan(children: [
                                        TextSpan(
                                            text: "10",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colours.color_333333,
                                            )),
                                        TextSpan(
                                            text: '个赞',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colours.color_333333,
                                            )),
                                      ]),
                                    ),
                                    Gaps.vGap4,
                                    const Text(
                                      "超过70%的同学",
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colours.color_906DA9,
                                      ),
                                    ),
                                  ],
                                )),
                            Container(
                                width: _screenUtil.screenWidth / 2 - 20,
                                height: 150,
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  color: Colours.color_EFF9FF,
                                ),
                                // padding: const EdgeInsets.symmetric(
                                //   horizontal: 35.0,
                                //   vertical: 15.0,
                                // ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const LoadAssetImage(
                                      "report_sentence_icon",
                                      width: 48.0,
                                      height: 48.0,
                                    ),
                                    Gaps.vGap10,
                                    RichText(
                                      text: const TextSpan(children: [
                                        TextSpan(
                                            text: "169",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colours.color_333333,
                                            )),
                                        TextSpan(
                                            text: '次开口',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
                                              color: Colours.color_333333,
                                            )),
                                      ]),
                                    ),
                                    Gaps.vGap4,
                                    const Text(
                                      "超过70%的同学",
                                      style: TextStyle(
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
                    // SliverToBoxAdapter(
                    //   child: Container(
                    //       color: Colors.white,
                    //       child: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8.0),
                    //             color: Colours.color_EFF9FF,
                    //           ),
                    //           margin: const EdgeInsets.all(10),
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 15.0,
                    //             vertical: 15.0,
                    //           ),
                    //           child: Row(
                    //             children: [
                    //               const LoadAssetImage(
                    //                 "fang_maike_icon",
                    //                 width: 48.0,
                    //                 height: 48.0,
                    //               ),
                    //               Gaps.hGap10,
                    //               const Expanded(
                    //                 child: Column(
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Text("开口102次",
                    //                         style: TextStyle(
                    //                           fontSize: 18,
                    //                           fontWeight: FontWeight.w400,
                    //                           color: Colors.black,
                    //                         )),
                    //                     Text("超过88%同学",
                    //                         style: TextStyle(
                    //                           fontSize: 14,
                    //                           color: Colours.color_666666,
                    //                         )),
                    //                   ],
                    //                 ),
                    //               ),
                    //               const CircleProgressView(
                    //                 height: 60,
                    //                 progress: 20,
                    //                 width: 60,
                    //               ),
                    //             ],
                    //           ))),
                    // ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: const LoadAssetImage(
                          "zan_icon",
                          width: 60.0,
                          height: 60.0,
                        ),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Gaps.vGap8,
                    // ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                            child: Text("这些句子的表达非常棒！",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ))),
                      ),
                    ),

                    SliverList.builder(
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: const ErrorCorrectionDetailTwoItem(),
                        );
                      },
                      itemCount: 4,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: const LoadAssetImage(
                          "liwu_icon",
                          width: 60.0,
                          height: 60.0,
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        color: Colors.white,
                        child: const Center(
                            child: Text("本节课收获",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ))),
                      ),
                    ),
                    // SliverToBoxAdapter(
                    //   child: Container(
                    //     color: Colors.white,
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //       children: [
                    //         CourseReportSelectItem(),
                    //         CourseReportSelectItem(),
                    //         CourseReportSelectItem(),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // headWidget("词汇", "12"),
                    const SliverToBoxAdapter(
                      child: CourseReportVocabularyItem(),
                    ),
                    // headWidget("句型", "12"),
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
                              Row(
                                children: [
                                  const LoadAssetImage(
                                    "home_head_icon",
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  // Gaps.hGap8,
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
                                      // const TextSpan(
                                      //     text: "个",
                                      //     style: TextStyle(
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.w400,
                                      //       color: Colours.color_666666,
                                      //     )),
                                    ]),
                                  ),
                                ],
                              ),
                              Gaps.vGap11,
                              const PlayBackItem(),
                              const PlayBackItem(),
                              const PlayBackItem(),
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
                              Row(
                                children: [
                                  const LoadAssetImage(
                                    "home_head_icon",
                                    width: 40.0,
                                    height: 40.0,
                                  ),
                                  // Gaps.hGap8,
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
                                      // const TextSpan(
                                      //     text: "个",
                                      //     style: TextStyle(
                                      //       fontSize: 16,
                                      //       fontWeight: FontWeight.w400,
                                      //       color: Colours.color_666666,
                                      //     )),
                                    ]),
                                  ),
                                ],
                              ),
                              Gaps.vGap11,
                              const PlayBackItem(),
                              const PlayBackItem(),
                              const PlayBackItem(),
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
