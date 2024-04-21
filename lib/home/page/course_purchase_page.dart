//课程购买
import 'dart:math';

import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:provider/provider.dart';

class CoursePurchasePage extends StatefulWidget {
  const CoursePurchasePage({super.key});

  @override
  State<CoursePurchasePage> createState() => _CoursePurchasePageState();
}

class _CoursePurchasePageState extends State<CoursePurchasePage> {
  RenderBox? boxTab;
  late Offset offsetTab;
  GlobalKey keyTab = GlobalKey(debugLabel: "university");
  bool isUpdateAppBar = false;

  Widget classImgWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Image.network(
        "http://t15.baidu.com/it/u=3515177818,2652149588&fm=224&app=112&f=JPEG?w=500&h=249",
        fit: BoxFit.fill,
      ),
    );
  }

  Widget classDetaileWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Text(
            "口语训练营",
            key: keyTab,
          ),
          const Text("时间"),
          const Text("价钱"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        body: SafeArea(
            child: Stack(children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              boxTab ??=
                  keyTab.currentContext!.findRenderObject() as RenderBox?;
              offsetTab = boxTab!.localToGlobal(Offset.zero);

              if (offsetTab.dy < 110.0) {
                isUpdateAppBar = true;
                // isUpdatePage = false;
                // isUpdateTheme = true;
              } else {
                isUpdateAppBar = false;
                // isUpdatePage = true;
                // isUpdateTheme = false;
              }
              setState(() {});

              return true;
            },
            child: extended.ExtendedNestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                // return buildSliverHeader();
                return [
                  // const SliverToBoxAdapter(
                  //   child: Text("Hello Tommy"),
                  // ),
                  // SliverPersistentHeader(
                  //     pinned: true,
                  //     floating: false,
                  //     delegate: _SliverAppBarDelegate(
                  //       minHeight: 25, //收起的高度
                  //       maxHeight: 25,
                  //       child: Container(
                  //           color: Colors.white, child: const Text("Hello Tommy")),
                  //     )),
                  SliverToBoxAdapter(
                    child: classImgWidget(context),
                  ),
                  SliverToBoxAdapter(
                    child: classDetaileWidget(context),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("双师服务"),
                  ),
                  const SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text("李老师"),
                        Text("李老师"),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("客户评价"),
                  ),
                  const SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text("评价1"),
                        Text("评价2"),
                      ],
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("课程详情"),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("巴拉巴拉"),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("适用人群"),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("巴拉巴拉"),
                  ),
                  const SliverToBoxAdapter(
                    child: Text("常见问题"),
                  ),
                ];
              },
              // pinnedHeaderSliverHeightBuilder: () {
              //   return 100;
              // },
              body: const Column(
                children: [
                  Text("第一个问题"),
                  Text("第二个问题"),
                ],
              ),
            ),
          ),
          isUpdateAppBar
              ? const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: XTCupertinoNavigationBar(
                    backgroundColor: Color(0xFFFFFFFF),
                    border: null,
                    padding: EdgeInsetsDirectional.zero,
                    leading: NavigationBackWidget(),
                    middle: Text(
                      "口语训练营",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ))
              : Positioned(
                  top: 0,
                  left: 10,
                  child: GestureDetector(
                      onTap: () {
                        NavigatorUtils.goBack(context);
                      },
                      child: const Text("返回"))),
          const Positioned(
              bottom: 0,
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("咨询"),
                      Text("立即支付"),
                    ],
                  ),
                  Text("条例"),
                ],
              )),
        ])),
      ),
    );
    // return const CupertinoPageScaffold(
    //   child: Scaffold(
    //       body: SafeArea(
    //     child: Text("介绍"),
    //   )),
    // );
  }
}

// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   _SliverAppBarDelegate({
//     required this.minHeight,
//     required this.maxHeight,
//     required this.child,
//   });

//   final double minHeight;
//   final double maxHeight;
//   final Widget child;

//   @override
//   double get minExtent => minHeight;

//   @override
//   double get maxExtent => max(maxHeight, minHeight);

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return SizedBox.expand(child: child);
//   }

//   @override
//   bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
//     return maxHeight != oldDelegate.maxHeight ||
//         minHeight != oldDelegate.minHeight ||
//         child != oldDelegate.child;
//   }
// }
