import 'dart:math';

import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/entity/lesson_list_bean.dart';
import 'package:Bubble/course/item/course_home_item.dart';
import 'package:Bubble/course/item/lesson_sele_item.dart';
import 'package:Bubble/course/presenter/course_home_page_presenter.dart';
import 'package:Bubble/course/view/course_home_page_view.dart';
import 'package:Bubble/home/home_router.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/util/confirm_utils.dart';
import 'package:Bubble/util/event_bus.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/util/notification_utils.dart';
import 'package:Bubble/util/toast_utils.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/navigation_bar_view.dart';
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
  bool isLoding = true;
  late String levelNameStr = "";

  List<Color> colorBackData = [
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
    Colours.color_F9F8FF,
    Colours.color_EFF9FF,
    Colours.color_E3FBFA,
  ];

  List<List<Color>> colorIconBackData = [
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
    [
      Colours.color_9F7EFF,
      Colours.color_BDA6FF,
    ],
    [
      Colours.color_7AAFFF,
      Colours.color_9AC3FF,
    ],
    [
      Colours.color_00CFD1,
      Colours.color_6EF0F1,
    ],
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventBus().on(NotificationUtils.loginIn, (_) {
      Future.delayed(const Duration(seconds: 1), () {
        _courseHomePagePresenter.getLessonList();

        // 这里是你想要延迟执行的代码
      });
    });
    EventBus().on(NotificationUtils.loginOut, (_) {
      Future.delayed(const Duration(seconds: 1), () {
        _courseHomePagePresenter.getLessonList();

        // 这里是你想要延迟执行的代码
      });
    });

    EventBus().on(NotificationUtils.resetChat, (idx) {
      if (idx == "1") {
        _courseHomePagePresenter.getLessonList();
      }
    });
    EventBus().on(NotificationUtils.paySuccess, (_) {
      Future.delayed(const Duration(seconds: 1), () {
        _courseHomePagePresenter.getLessonList();

        // 这里是你想要延迟执行的代码
      });
      // 这里是你想要延迟执行的代码
    });
  }

  @override
  void dispose() {
    super.dispose();
    EventBus().off(NotificationUtils.paySuccess);

    EventBus().off(NotificationUtils.loginIn);
    EventBus().off(NotificationUtils.loginOut);
    EventBus().off(NotificationUtils.resetChat);
  }

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
      height: 45,
      width: _screenUtil.screenWidth,
      color: const Color(0xFFFFFFFF),
      child: Center(
        child: Column(
          children: [
            Container(
              height: 15,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showView(int levelId) {
    ConfirmUtils.show(
      context: context,
      title: '提示',
      buttonDirection: 'vertical',
      confirmButtonText: '暂不购买',
      cancelButtonText: '立即购买',
      onConfirm: () {},
      onCancel: () {
        //去购买页
        NavigatorUtils.push(
          context,
          "${HomeRouter.coursePurchasePage}?levelId=$levelId",
        );
      },
      child: const Text(
        '购买课程即可开始学习',
        style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Color(0xFF333333),
          height: 18.0 / 15.0,
        ),
      ),
    );
  }

  List<Widget> _buildItems(
      List<UnitList> xxlist, Color backColor, List<Color> iconBackColor) {
    List<Widget> list = [];
    for (int i = 0; i < xxlist.length; i++) {
      list.add(GestureDetector(
          onTap: () {
            // showView(xxlist[i].levelId);
            if (xxlist[i].isUserBuy == 1) {
              //去上课
              if (xxlist[i].isLocked == 0) {
                NavigatorUtils.push(
                    context,
                    // CourseRouter.courseFlowPage,
                    "${CourseRouter.courseFlowPage}?lessonId=${xxlist[i].lessonId}");
              } else {
                Toast.show(
                  '需要老师安排课才能上课',
                );
              }
            } else {
              if (xxlist[i].isLocked == 0) {
                NavigatorUtils.push(
                    context,
                    // CourseRouter.courseFlowPage,
                    "${CourseRouter.courseFlowPage}?lessonId=${xxlist[i].lessonId}");
              } else {
                showView(xxlist[i].levelId);
              }
            }
          },
          child: CourseHomeItem(
            index: i + 1,
            unitData: xxlist[i],
            backColor: backColor,
            iconBackColor: iconBackColor,
          )));
    }
    return list;
  }

  Widget _buildStickyHeader(List<UnitList> list, String tit, Color backColor,
      List<Color> iconBackColor) {
    return StickyHeader(
      header: _headTitle(tit),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _buildItems(list, backColor, iconBackColor),
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

              return _buildStickyHeader(list, xxlist[index].unitName,
                  colorBackData[index], colorIconBackData[index]);
            },
            childCount: listData[curTabIndex].list.length,
          ),
        ),
      ],
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
    // if (isloading) {
    //   return const Scaffold(
    //     body: Center(
    //       child: LoadData(),
    //     ),
    //   );
    // }
    return AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
            body: SafeArea(
          child: isLoding
              ? lodingView()
              : Column(
                  children: [
                    listData.length > 1
                        ? tabbar()
                        : XTCupertinoNavigationBar(
                            backgroundColor: Color(0xFFFFFFFF),
                            border: null,
                            padding: EdgeInsetsDirectional.zero,
                            middle: Text(
                              levelNameStr,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                    // NavigationBaView(
                    //     title: levelNameStr,
                    //   ),
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
      listData = [];

      isLoding = false;
      if (data.data.isNotEmpty) {
        levelNameStr = data.data[0].levelName;
      }
      listData.addAll(data.data);
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}
