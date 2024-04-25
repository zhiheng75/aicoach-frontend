import 'dart:math';

import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/item/course_home_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  int curTabIndex = 0;

  Widget tabbar() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Container(
            width: 80,
            height: 50,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: Colours.color_007AFF,
            ),
            padding: const EdgeInsets.only(right: 8, left: 8.0),
            child: const Center(
                child: Text(
              "Level 1",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )),
          );
        },
        itemCount: 3,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (isloading) {
    //   return const Scaffold(
    //     body: Center(
    //       child: LoadData(),
    //     ),
    //   );
    // }
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
            child: extended.ExtendedNestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: _SliverAppBarDelegate(
                    minHeight: 50, //收起的高度
                    maxHeight: 50,
                    child: Center(child: SizedBox(width: 300, child: tabbar())),
                  )),
              const SliverToBoxAdapter(
                child: Center(
                    child: Text(
                  "Unit2 朋友见面",
                  style: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                )),
              ),
            ];
          },
          // pinnedHeaderSliverHeightBuilder: () {
          //   return 100;
          // },
          body: ListView.builder(
            itemBuilder: (ctx, index) {
              return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      NavigatorUtils.push(
                        context,
                        CourseRouter.courseDetailsPage,
                      );
                    } else if (index == 1) {
                      NavigatorUtils.push(
                        context,
                        CourseRouter.courseReportPage,
                      );
                    } else if (index == 2) {
                      NavigatorUtils.push(
                        context,
                        CourseRouter.curriculumEvaluationPage,
                      );
                    } else {
                      NavigatorUtils.push(
                        context,
                        CourseRouter.courseFlowPage,
                      );
                    }

                    // NavigatorUtils.push(
                    //     context,
                    //     "${ClassRouter.classFlowPage}?index=0",
                    //   );
                  },
                  child: const CourseHomeItem());
            },
            itemCount: 100,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
        )),
      ),
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
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
