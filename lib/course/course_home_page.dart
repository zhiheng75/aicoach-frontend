import 'dart:math';

import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/entity/lesson_list_bean.dart';
import 'package:Bubble/course/item/course_home_item.dart';
import 'package:Bubble/course/item/lesson_sele_item.dart';
import 'package:Bubble/course/presenter/course_home_page_presenter.dart';
import 'package:Bubble/course/view/course_home_page_view.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key});

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage>
    with
        BasePageMixin<CourseHomePage, CourseHomePagePresenter>,
        RouteAware,
        AutomaticKeepAliveClientMixin<CourseHomePage>
    implements CourseHomePageView {
  int curTabIndex = 0;
  final ScreenUtil _screenUtil = ScreenUtil();
  late CourseHomePagePresenter _courseHomePagePresenter;
  late List<Datum> listData = [];

  Widget tabbar() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              setState(() {
                curTabIndex = index;
              });
            },
            child: LessonSeleItem(
              tit: listData[index].levelName,
              sele: curTabIndex == index ? true : false,
            ),
          );
        },
        itemCount: listData.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Widget _headTitle(String title) {
    return Container(
      width: _screenUtil.screenWidth,
      color: const Color(0xFFFFFFFF),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, top: 6, bottom: 6),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItems(List<UnitList> xxlist) {
    List<Widget> list = [];
    for (int i = 0; i < xxlist.length; i++) {
      list.add(GestureDetector(
          onTap: () {
            NavigatorUtils.push(
                context,
                // CourseRouter.courseFlowPage,
                "${CourseRouter.courseFlowPage}?lessonId=${xxlist[i].lessonId}");
          },
          child: CourseHomeItem(
            index: i + 1,
            unitData: xxlist[i],
          )));
    }
    return list;
  }

  Widget _buildStickyHeader(List<UnitList> list, String tit) {
    return StickyHeader(
      header: _headTitle(tit),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildItems(list),
      ),
    );
  }

  Widget _refreshListView() {
    // print(listData[curTabIndex].list.length);
    // Log.e(listData[curTabIndex].list.length as String);

    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (ctx, index) {
              // return _buildItem(dataList[index]);
              // List<DatumList> listData = listData[curTabIndex].list;
              List<Datum> xxlistData = listData;
              List<LevelList> xxlist = xxlistData[curTabIndex].list;
              List<UnitList> list = xxlist[index].list;

              return _buildStickyHeader(list, xxlist[index].unitName);
            },
            childCount: listData[curTabIndex].list.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          child: Column(
            children: [
              listData.length > 1 ? tabbar() : Container(),
              // Center(child: SizedBox(width: 300, child: tabbar())),
              Expanded(child: _refreshListView()),
            ],
          ),
        )));

    //      extended.ExtendedNestedScrollView(
    //   headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
    //     return [
    //       SliverPersistentHeader(
    //           pinned: true,
    //           floating: false,
    //           delegate: _SliverAppBarDelegate(
    //             minHeight: 50, //收起的高度
    //             maxHeight: 50,
    //             child: Center(child: SizedBox(width: 300, child: tabbar())),
    //           )),
    //       const SliverToBoxAdapter(
    //         child: Center(
    //             child: Text(
    // "Unit2 朋友见面",
    // style: TextStyle(
    //   fontSize: 17.0,
    //   fontWeight: FontWeight.w400,
    //   color: Colors.black,
    // ),
    //         )),
    //       ),
    //     ];
    //   },
    //   // pinnedHeaderSliverHeightBuilder: () {
    //   //   return 100;
    //   // },
    //   body: ListView.builder(
    //     itemBuilder: (ctx, index) {
    //       return GestureDetector(
    //           onTap: () {
    // if (index == 0) {
    //   NavigatorUtils.push(
    //     context,
    //     CourseRouter.courseDetailsPage,
    //   );
    // } else if (index == 1) {
    // NavigatorUtils.push(
    //   context,
    //   CourseRouter.courseReportPage,
    // );
    // } else if (index == 2) {
    //   NavigatorUtils.push(
    //     context,
    //     CourseRouter.curriculumEvaluationPage,
    //   );
    // } else {
    //   NavigatorUtils.push(
    //     context,
    //     CourseRouter.courseFlowPage,
    //   );
    // }

    //             // NavigatorUtils.push(
    //             //     context,
    //             //     "${ClassRouter.classFlowPage}?index=0",
    //             //   );
    //           },
    //           child: const CourseHomeItem());
    //     },
    //     itemCount: 10,
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //   ),
    // )),
  }

  @override
  CourseHomePagePresenter createPresenter() {
    // TODO: implement createPresenter
    _courseHomePagePresenter = CourseHomePagePresenter();
    return _courseHomePagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(LessonListBean data) {
    setState(() {
      listData.addAll(data.data);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
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
