//课程报告
import 'dart:math';

import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseReportPage extends StatefulWidget {
  const CourseReportPage({super.key});

  @override
  State<CourseReportPage> createState() => _CourseReportPageState();
}

class _CourseReportPageState extends State<CourseReportPage> {
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
                            padding: const EdgeInsets.only(top: 50),
                            margin: const EdgeInsets.only(top: 50),
                            color: Colors.white,
                            child: const Column(
                              children: [
                                Text("欧阳小明"),
                                Text("认识动物"),
                                Text("认识动物"),
                                Text("认识动物"),
                              ],
                            ),
                          ),
                          const Positioned(
                              // top: 0,
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("1111"),
                            ],
                          ))
                        ],
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Text("用户相关信息"),
                    ),
                    const SliverToBoxAdapter(
                      child: Text("口语评测结果"),
                    ),
                    const SliverToBoxAdapter(
                      child: Text("优秀表达"),
                    ),
                    SliverList.builder(
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: const Text("boagao"),
                        );
                      },
                      itemCount: 3,
                    ),
                    const SliverToBoxAdapter(
                      child: Text("我的优秀表达"),
                    ),
                    SliverList.builder(
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: const Text("boagao"),
                        );
                      },
                      itemCount: 3,
                    ),
                    const SliverToBoxAdapter(
                      child: Text("本节课收货"),
                    ),
                    const SliverToBoxAdapter(
                      child: Text("举行学习学习"),
                    ),
                    SliverList.builder(
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: const Text("boagao"),
                        );
                      },
                      itemCount: 3,
                    ),
                    const SliverToBoxAdapter(
                      child: Text("给本节课打个分"),
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
