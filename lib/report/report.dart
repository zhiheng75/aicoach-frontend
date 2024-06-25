// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:Bubble/course/course_router.dart';
import 'package:Bubble/course/item/course_home_item.dart';
import 'package:Bubble/course/item/lesson_sele_item.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/report/entity/lesson_reports_bean.dart';
import 'package:Bubble/report/widget/course_report_class_item.dart';
import 'package:Bubble/res/gaps.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/util/event_um_statistics.dart';
import 'package:Bubble/widgets/bx_cupertino_navigation_bar.dart';
import 'package:Bubble/widgets/load_data.dart';
import 'package:Bubble/widgets/load_fail.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../mvp/base_page.dart';
import '../net/http_api.dart';
import '../res/colors.dart';
import '../routers/fluro_navigator.dart';
import '../widgets/navbar.dart';
import 'entity/chat_report_entity.dart';
import 'entity/exam_report_entity.dart';
import 'presenter/report_page_presenter.dart';
import 'report_router.dart';
import 'view/report_view.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage>
    with
        BasePageMixin<ReportPage, ReportPagePresenter>,
        AutomaticKeepAliveClientMixin<ReportPage>
    implements ReportView {
  late ReportPagePresenter _reportPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  String _type = 'class';
  int _page = 1;
  int _loading = 0;
  String _state = '';
  List<dynamic> _list = [];
  CancelToken? _cancelToken;
  String _message = '你还没有系统课报告，快去上课吧！';
  List<ReportsDatum> _reportsData = [];

  int curTabIndex = 0;

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
  void init() {
    _page = 1;
    getMore();
  }

  void getMore() {
    _loading = 1;
    _state = '';
    setState(() {});
    if (_type == 'chat') {
      getChatReportList();
    } else if (_type == 'exam') {
      getExamReortList();
    } else if (_type == 'class') {
      getChatClassList();
    }
  }

  void getChatClassList() async {
    if (_cancelToken != null && _loading == 1) {
      _cancelToken!.cancel();
    }
    _cancelToken = CancelToken();
    if (_page == 1) {
      _reportsData = [];
    }
    _reportPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.lessonReports,
      isShow: false,
      isClose: false,
      cancelToken: _cancelToken,
      onSuccess: (result) {
        _cancelToken = null;
        if (result == null || result.data == null) {
          _loading = 0;
          _state = 'fail';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        Map<String, dynamic> lessonReportsMap = json.decode(result.toString());
        LessonReportsBean lessonReportsBean =
            LessonReportsBean.fromJson(lessonReportsMap);
        _reportsData.addAll(lessonReportsBean.data);
        // _list.addAll(list);
        _loading = 0;
        _state = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        _cancelToken = null;
        _loading = 0;
        _state = 'fail';
        if (mounted) {
          setState(() {});
        }
      },
    );

    _state = 'success';
    _loading = 0;
    setState(() {});
  }

  void getChatReportList() async {
    if (_cancelToken != null && _loading == 1) {
      _cancelToken!.cancel();
    }
    _cancelToken = CancelToken();
    if (_page == 1) {
      _list = [];
    }
    _reportPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.studyReportList,
      isShow: false,
      isClose: false,
      cancelToken: _cancelToken,
      queryParameters: {
        'device_id': await Device.getDeviceId(),
      },
      onSuccess: (result) {
        _cancelToken = null;
        if (result == null || result.data == null) {
          _loading = 0;
          _state = 'fail';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<ChatReportEntity> list =
            data.map((item) => ChatReportEntity.fromJson(item)).toList();
        _list.addAll(list);
        _loading = 0;
        _state = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        _cancelToken = null;
        _loading = 0;
        _state = 'fail';
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void getExamReortList() {
    if (_cancelToken != null && _loading == 1) {
      _cancelToken!.cancel();
    }
    _cancelToken = CancelToken();
    if (_page == 1) {
      _list = [];
    }
    _reportPagePresenter.requestNetwork<ResultData>(
      Method.get,
      url: HttpApi.examReportList,
      isShow: false,
      isClose: false,
      cancelToken: _cancelToken,
      onSuccess: (result) {
        _cancelToken = null;
        if (result == null || result.data == null) {
          _loading = 0;
          _state = 'fail';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        List<dynamic> data = result.data as List<dynamic>;
        List<ExamReportEntity> list =
            data.map((item) => ExamReportEntity.fromJson(item)).toList();
        _list.addAll(list);
        _loading = 0;
        _state = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        _cancelToken = null;
        _loading = 0;
        _state = 'fail';
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  dynamic formatData(dynamic data) {
    if (_type == 'chat') {
      return ChatReportEntity.fromJson(data);
    }
    return ExamReportEntity.fromJson(data);
  }

  Color getColorByScore(double score) {
    Color color;
    if (score < 50) {
      color = const Color(0xFFE00094);
    } else if (score < 80) {
      color = const Color(0xFF020000);
    } else {
      color = const Color(0xFF24B340);
    }
    return color;
  }

  @override
  void initState() {
    super.initState();
    init();
    EventUMStatistics.umengCommonOnPageStart("report_page");
  }

  @override
  void dispose() {
    EventUMStatistics.umengCommonOnPageEnd("report_page");

    if (_cancelToken != null && _loading == 1) {
      _cancelToken!.cancel();
    }
    super.dispose();
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
              // List<ReportsDatum> _reportsData
              List<ReportsDatum> xxlistData = _reportsData;
              List<DatumList> xxlist = xxlistData[curTabIndex].list;
              List<ListList> list = xxlist[index].list;

              return _buildStickyHeader(list, xxlist[index].unitName,
                  colorBackData[index], colorIconBackData[index]);
            },
            childCount: _reportsData[curTabIndex].list.length,
          ),
        ),
      ],
    );
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
                "${CourseRouter.courseReportPage}?lessonId=${xxlist[i].lessonId}");

            // NavigatorUtils.push(
            //     context,
            //     // CourseRouter.courseFlowPage,
            //     "${CourseRouter.courseFlowPage}?lessonId=${xxlist[i].lessonId}");
          },
          child: CourseReportClassItem(
            index: i + 1,
            unitData: xxlist[i],
            backColor: backColor,
            iconBackColor: iconBackColor,
          )));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget navbar = const Navbar(
      title: '学情报告',
    );

    Widget star(num score) {
      List<Widget> children = [];
      int count = 0;
      if (score >= 92) {
        count = 5;
      } else if (score >= 80) {
        count = 4;
      } else if (score >= 60) {
        count = 3;
      } else if (score >= 50) {
        count = 2;
      } else {
        count = 1;
      }
      while (count > 0) {
        children.add(const LoadAssetImage(
          'star',
          width: 16.0,
          height: 15.0,
        ));
        count--;
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    Widget barItem(String label, String type) {
      bool isSelected = _type == type;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          _type = type;
          if (type == "class") {
            _message = '你还没有系统课报告，快去上课吧！';
          } else if (type == "chat") {
            _message = '还没有口语学习报告，\n快点开始学习吧！';
          } else if (type == "exam") {
            _message = '还没有模考报告喔！';
          }
          _page = 1;
          _list = [];
          setState(() {});
          getMore();
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 8, bottom: 8),
          // width: 102.0,
          // height: 34.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color:
                isSelected ? const Color(0xFF0047FF) : const Color(0xFFF3F5F7),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF333333),
            ),
          ),
        ),
      );
    }

    Widget tabbar = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // barItem('口语课报告', 'chat'),
        // const SizedBox(
        //   width: 8.0,
        // ),
        barItem('系统课报告', 'class'),
        Gaps.hGap8,

        barItem('口语练习报告', 'chat'),
        Gaps.hGap8,

        barItem('模考报告', 'exam'), //隐藏
      ],
    );

    Widget listItem(dynamic item) {
      Widget content = const SizedBox();
      if (_type == 'chat') {
        String sessionId = '';
        if (item is ChatReportEntity) {
          sessionId = item.sessionId;
        }
        content = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.push(
              context,
              ReportRouter.reportDetailPage,
              arguments: {
                'sessionId': sessionId,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (item.topicName == '自由对话')
                      SizedBox(
                        width: 118.0,
                        height: 118.0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: SingleChildScrollView(
                            physics: const NeverScrollableScrollPhysics(),
                            child: LoadImage(
                              item.topicCover,
                              width: 118.0,
                            ),
                          ),
                        ),
                      ),
                    if (item.topicName != '自由对话')
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: LoadImage(
                          item.topicCover,
                          width: 118.0,
                          height: 118.0,
                        ),
                      ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: _screenUtil.screenWidth - 220,
                          child: Text(
                            item.topicName,
                            maxLines: 2,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              height: 18.0 / 16.0,
                              letterSpacing: 0.05,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(
                          '时长：${item.duration > 60 ? '${item.duration ~/ 60}min' : '${item.duration}s'}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.0 / 14.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                        Text(
                          item.createTime,
                          style: const TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_999999,
                            height: 18.0 / 11.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        star(item.score.toInt()),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${item.score.toInt()}',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w400,
                            color: getColorByScore(item.score),
                            letterSpacing: 0.05,
                          ),
                        ),
                        const Text(
                          '总分',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_999999,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 7.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(
                          width: 32.0,
                          height: 32.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.0),
                            child: SingleChildScrollView(
                              physics: const NeverScrollableScrollPhysics(),
                              child: LoadImage(
                                item.topicCover,
                                width: 32.0,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          item.characterName,
                          style: const TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.0 / 10.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      if (_type == 'exam') {
        item = item as ExamReportEntity;
        int id = item.id;
        content = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.push(
              context,
              '${ReportRouter.myExaminationPage}?id=$id',
              // arguments: {
              //   'id': id,
              // },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 18.0 / 16.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      '时长：${item.duration > 60 ? '${item.duration ~/ 60}min' : '${item.duration}s'}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF666666),
                        height: 18.0 / 14.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                    Text(
                      item.createTime,
                      style: const TextStyle(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_999999,
                        height: 18.0 / 11.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          '${item.score}',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w400,
                            color: getColorByScore(
                                double.parse(item.score.toString())),
                            letterSpacing: 0.05,
                          ),
                        ),
                        const Text(
                          '总分',
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w400,
                            color: Colours.color_999999,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 7.0,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: LoadImage(
                            item.examinerAvatar,
                            width: 32.0,
                            height: 32.0,
                          ),
                        ),
                        const Text(
                          '主考官',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 18.0 / 10.0,
                            letterSpacing: 0.05,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
      // if (_type == 'class') {
      //   //  String sessionId = '';
      //   // if (item is ChatReportEntity) {
      //   //   sessionId = item.sessionId;
      //   // }
      //   content = GestureDetector(
      //     behavior: HitTestBehavior.opaque,
      //     onTap: () {
      //       NavigatorUtils.push(
      //         context,
      //         CourseRouter.courseReportPage,
      //       );
      //       // NavigatorUtils.push(
      //       //   context,
      //       //   ReportRouter.reportDetailPage,
      //       //   arguments: {
      //       //     'sessionId': sessionId,
      //       //   },
      //       // );
      //     },
      //     child: Container(
      //       margin: const EdgeInsets.all(10),
      //       // padding: const EdgeInsets.only(
      //       //   right: 16.0,
      //       // ),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: <Widget>[
      //           Row(
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               const SizedBox(
      //                 width: 8.0,
      //               ),
      //               Container(
      //                 width: 60,
      //                 height: 60,
      //                 // margin: const EdgeInsets.only(top: 10),
      //                 decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(8.0),
      //                   color: Colors.white,
      //                 ),
      //                 // padding: const EdgeInsets.symmetric(
      //                 //   horizontal: 10.0,
      //                 //   vertical: 10.0,
      //                 // ),
      //                 child: const Column(
      //                   mainAxisAlignment: MainAxisAlignment.center,
      //                   children: [
      //                     Text(
      //                       "1",
      //                       style: TextStyle(
      //                         fontSize: 20.0,
      //                         fontWeight: FontWeight.w400,
      //                         color: Colors.black,
      //                       ),
      //                     ),
      //                     Text(
      //                       "Lesson",
      //                       style: TextStyle(
      //                         fontSize: 13.0,
      //                         fontWeight: FontWeight.w400,
      //                         color: Colors.black,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //               const SizedBox(
      //                 width: 8.0,
      //               ),
      //               Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   const Text(
      //                     '农场动物',
      //                     style: TextStyle(
      //                       fontSize: 16.0,
      //                       fontWeight: FontWeight.w500,
      //                       color: Colors.black,
      //                       height: 18.0 / 16.0,
      //                       letterSpacing: 0.05,
      //                     ),
      //                   ),
      //                   const Text(
      //                     "学习时间:2024-4-6",
      //                     style: TextStyle(
      //                       fontSize: 11.0,
      //                       fontWeight: FontWeight.w400,
      //                       color: Colours.color_999999,
      //                       height: 18.0 / 11.0,
      //                       letterSpacing: 0.05,
      //                     ),
      //                   ),
      //                   const SizedBox(
      //                     height: 8.0,
      //                   ),
      //                   star(100),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: <Widget>[
      //                   Text(
      //                     '100',
      //                     style: TextStyle(
      //                       fontSize: 24.0,
      //                       fontWeight: FontWeight.w400,
      //                       color: getColorByScore(item.score),
      //                       letterSpacing: 0.05,
      //                     ),
      //                   ),
      //                   const Text(
      //                     '综合得分',
      //                     style: TextStyle(
      //                       fontSize: 11.0,
      //                       fontWeight: FontWeight.w400,
      //                       color: Colours.color_999999,
      //                       letterSpacing: 0.05,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               const SizedBox(
      //                 height: 7.0,
      //               ),
      //               // Column(
      //               //   mainAxisSize: MainAxisSize.min,
      //               //   children: <Widget>[
      //               //     SizedBox(
      //               //       width: 32.0,
      //               //       height: 32.0,
      //               //       child: ClipRRect(
      //               //         borderRadius: BorderRadius.circular(32.0),
      //               //         child: const SingleChildScrollView(
      //               //           physics: NeverScrollableScrollPhysics(),
      //               //           child: LoadImage(
      //               //             "https://statics.shenmo-ai.com/sophia.jpg",
      //               //             width: 32.0,
      //               //           ),
      //               //         ),
      //               //       ),
      //               //     ),
      //               //     const Text(
      //               //       "ssss",
      //               //       style: TextStyle(
      //               //         fontSize: 10.0,
      //               //         fontWeight: FontWeight.w400,
      //               //         color: Color(0xFF666666),
      //               //         height: 18.0 / 10.0,
      //               //         letterSpacing: 0.05,
      //               //       ),
      //               //     ),
      //               //   ],
      //               // ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     ),
      //   );
      // }
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: const Color(0xFFF8F8F8),
          ),
          child: content,
        ),
      );
    }

    Widget list = const SizedBox();

    if (_loading == 1) {
      list = const Center(
        child: LoadData(),
      );
    }

    if (_loading == 0) {
      if (_state == 'success') {
        if (_type == 'class') {
          if (_reportsData.length == 0) {
            list = Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const LoadAssetImage(
                    'no_data',
                    width: 63.0,
                    height: 63.0,
                  ),
                  const SizedBox(
                    height: 21.0,
                  ),
                  Text(
                    _message,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_999999,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (_reportsData[curTabIndex].list.isEmpty) {
              list = Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const LoadAssetImage(
                      'no_data',
                      width: 63.0,
                      height: 63.0,
                    ),
                    const SizedBox(
                      height: 21.0,
                    ),
                    Text(
                      _message,
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                        color: Colours.color_999999,
                        letterSpacing: 0.05,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              if (_type == 'class') {
                list = _refreshListView();
              } else {
                list = ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _type == "class" ? 10 : _list.length,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.only(
                      bottom: i == _list.length - 1 ? 0 : 16.0,
                    ),
                    child: listItem(_list.elementAt(i)),
                  ),
                );
              }
            }
          }
        } else {
          if (_list.isEmpty) {
            list = Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const LoadAssetImage(
                    'no_data',
                    width: 63.0,
                    height: 63.0,
                  ),
                  const SizedBox(
                    height: 21.0,
                  ),
                  Text(
                    _message,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                      color: Colours.color_999999,
                      letterSpacing: 0.05,
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (_type == 'class') {
              list = ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 10,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(
                    bottom: i == _list.length - 1 ? 0 : 16.0,
                  ),
                  child: const Text("1111"),
                ),
              );
            } else {
              list = ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _type == "class" ? 10 : _list.length,
                itemBuilder: (_, i) => Padding(
                  padding: EdgeInsets.only(
                    bottom: i == _list.length - 1 ? 0 : 16.0,
                  ),
                  child: listItem(_list.elementAt(i)),
                ),
              );
            }
          }
        }
      }
      if (_state == 'fail') {
        list = Center(
          child: LoadFail(
            reload: () {
              _page = 1;
              getMore();
            },
          ),
        );
      }
    }

    Widget twoTabbar() {
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
                tit: _reportsData[index].levelName,
                sele: curTabIndex == index ? true : false,
              ),
            );
          },
          itemCount: _reportsData.length,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
        ),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: const XTCupertinoNavigationBar(
        backgroundColor: Color(0xFFFFFFFF),
        border: null,
        padding: EdgeInsetsDirectional.zero,
        leading: NavigationBackWidget(),
        middle: Text(
          "学情报告",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            children: <Widget>[
              // const SizedBox(
              //   height: 60.0,
              // ),
              // navbar,
              const SizedBox(
                height: 16.0,
              ),
              tabbar,
              const SizedBox(
                height: 20.0,
              ),
              _type == "class"
                  ? _reportsData.length == 1
                      ? Container()
                      : twoTabbar()
                  : Container(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: _screenUtil.bottomBarHeight,
                  ),
                  child: list,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  ReportPagePresenter createPresenter() {
    _reportPagePresenter = ReportPagePresenter();
    return _reportPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}
