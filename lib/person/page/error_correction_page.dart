import 'package:Bubble/course/item/lesson_sele_item.dart';
import 'package:Bubble/mvp/base_page.dart';
import 'package:Bubble/person/entity/mistake_records_bean.dart';
import 'package:Bubble/person/person_router.dart';

import 'package:Bubble/person/presneter/error_correction_page_presenter.dart';
import 'package:Bubble/person/view/error_correction_page_view.dart';
import 'package:Bubble/person/widget/course_error_class_item.dart';
import 'package:Bubble/res/colors.dart';
import 'package:Bubble/routers/fluro_navigator.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class ErrorCorrectionPage extends StatefulWidget {
  const ErrorCorrectionPage({super.key});

  @override
  State<ErrorCorrectionPage> createState() => _ErrorCorrectionPageState();
}

class _ErrorCorrectionPageState extends State<ErrorCorrectionPage>
    with
        BasePageMixin<ErrorCorrectionPage, ErrorCorrectionPagePresenter>,
        AutomaticKeepAliveClientMixin<ErrorCorrectionPage>
    implements ErrorCorrectionPageView {
  late ErrorCorrectionPagePresenter _errorCorrectionPagePresenter;
  late List<MistakeDatum> mistakelistData = [];
  bool isLoding = true;
  int curTabIndex = 0;
  final ScreenUtil _screenUtil = ScreenUtil();

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

  Widget lodingView() {
    return const Center(
      child: CircularProgressIndicator(),
    );
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
              tit: mistakelistData[index].levelName,
              sele: curTabIndex == index ? true : false,
            ),
          );
        },
        itemCount: mistakelistData.length,
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

  List<Widget> _buildItems(
      List<ListList> xxlist, Color backColor, List<Color> iconBackColor) {
    List<Widget> list = [];
    for (int i = 0; i < xxlist.length; i++) {
      list.add(GestureDetector(
          onTap: () {
            NavigatorUtils.push(context,
                "${PersonalRouter.errorCorrectionDetailPage}?lessonId=${xxlist[i].lessonId}");
          },
          child: CourseErrorClassItem(
            index: i + 1,
            unitData: xxlist[i],
            backColor: backColor,
            iconBackColor: iconBackColor,
          )));
    }
    return list;
  }

  Widget _buildStickyHeader(List<ListList> list, String tit, Color backColor,
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
              List<MistakeDatum> xxlistData = mistakelistData;
              List<DatumList> xxlist = xxlistData[curTabIndex].list;
              List<ListList> list = xxlist[index].list;

              return _buildStickyHeader(list, xxlist[index].unitName,
                  colorBackData[index], colorIconBackData[index]);
            },
            childCount: mistakelistData[curTabIndex].list.length,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "纠错列表",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
          body: SafeArea(
        child: isLoding
            ? lodingView()
            : Column(
                children: [
                  mistakelistData.length > 1 ? tabbar() : Container(),
                  // Center(child: SizedBox(width: 300, child: tabbar())),
                  mistakelistData.isNotEmpty
                      ? Expanded(child: _refreshListView())
                      : Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              height: 200,
                            ),
                            const LoadAssetImage(
                              'no_data',
                              width: 63.0,
                              height: 63.0,
                            ),
                            const SizedBox(
                              height: 21.0,
                            ),
                            const Text(
                              "这节课表现太优秀了\n没有待纠错内容，继续加油!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w400,
                                color: Colours.color_999999,
                                letterSpacing: 0.05,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
      )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;

  @override
  ErrorCorrectionPagePresenter createPresenter() {
    // TODO: implement createPresenter
    _errorCorrectionPagePresenter = ErrorCorrectionPagePresenter();
    return _errorCorrectionPagePresenter;
  }

  @override
  void sendFail(String msg) {
    // TODO: implement sendFail
  }

  @override
  void sendSuccess(MistakeRecordsBean msg) {
    // TODO: implement sendSuccess
    setState(() {
      isLoding = false;
      mistakelistData.addAll(msg.data);
    });
  }
}
