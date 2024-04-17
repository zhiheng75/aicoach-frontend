import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;

class ClassHomePage extends StatefulWidget {
  const ClassHomePage({super.key});

  @override
  State<ClassHomePage> createState() => _ClassHomePageState();
}

class _ClassHomePageState extends State<ClassHomePage> {
  int curTabIndex = 0;

  Widget tabbar() {
    return SizedBox(
      height: 30,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 8, left: 8.0),
            child: Text("LEVEL1"),
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
                    minHeight: 40, //收起的高度
                    maxHeight: 40,
                    child: Container(color: Colors.white, child: tabbar()),
                  ))
            ];
          },
          // pinnedHeaderSliverHeightBuilder: () {
          //   return 100;
          // },
          body: ListView.builder(
            itemBuilder: (ctx, index) {
              return SizedBox(
                  height: 100, child: Center(child: Text("课程$index")));
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
