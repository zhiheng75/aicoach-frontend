// ignore_for_file: prefer_final_fields

import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../exam/exam_router.dart';
import '../mvp/base_page.dart';
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
  String _type = 'chat';
  int _page = 1;
  int _loading = 0;
  List<dynamic> _list = [];

  void init() {
    _page = 1;
    getMore();
  }

  void getMore() {
    _loading = 1;
    setState(() {});
    // todo 对接列表接口
    Future.delayed(const Duration(seconds: 1), () {
      List<dynamic> list = [];
      for (int i = 0; i < 10; i++) {
        Map<String, dynamic> data = {
          'id': i,
          'topic_cover': '',
          'topic_name': '探索挪威',
          'star': 4,
          'character_name': '爱丽丝',
          'character_avatar': '',
          'name': '模考$i',
          'duration': 900,
          'score': 90,
          'examiner_avatar': '',
          'examiner_name': '考官',
          'create_time': '2023-12-31 23:59:59'
        };
        dynamic item = formatData(data);
        list.add(item);
      }
      _list.addAll(list);
      _loading = 0;
      setState(() {});
    });
  }

  dynamic formatData(dynamic data) {
    if (_type == 'chat') {
      return ChatReportEntity.fromJson(data);
    }
    return ExamReportEntity.fromJson(data);
  }

  Color getColorByScore(int score) {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget navbar = const Navbar(
      title: '学情报告',
    );

    Widget barItem(String label, String type) {
      bool isSelected = _type == type;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          _type = type;
          _page = 1;
          _list = [];
          setState(() {});
          getMore();
        },
        child: Container(
          width: 102.0,
          height: 34.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40.0),
            color:
                isSelected ? const Color(0xFF007AFF) : const Color(0xFFF3F5F7),
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        barItem('口语课报告', 'chat'),
        const SizedBox(
          width: 8.0,
        ),
        barItem('模考报告', 'exam'),
      ],
    );

    Widget listItem(dynamic item) {
      Widget content = const SizedBox();
      if (_type == 'chat') {
        item = item as ChatReportEntity;
        int id = item.id;
        content = GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtils.push(
              context,
              ReportRouter.reportDetailPage,
              arguments: {
                'id': id,
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
                        Text(
                          item.topicName,
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
                          '时长：${item.duration ~/ 60}min',
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
                          '${item.score}',
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: LoadImage(
                            item.topicCover,
                            width: 32.0,
                            height: 32.0,
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
              ExamRouter.examDetailPage,
              arguments: {
                'id': id,
              },
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
                      '时长：${item.duration ~/ 60}min',
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
                        Text(
                          item.examinerName,
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

    if (_loading == 0 && _list.isEmpty) {
      list = Container(
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            LoadAssetImage(
              'no_data',
              width: 63.0,
              height: 63.0,
            ),
            SizedBox(
              height: 21.0,
            ),
            Text(
              '还没有口语学习报告，\n快点开始学习吧！',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colours.color_999999,
                letterSpacing: 0.05,
              ),
            ),
          ],
        ),
      );
    }

    if (_loading == 0 && _list.isNotEmpty) {
      list = ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _list.length,
        itemBuilder: (_, i) => Padding(
          padding: EdgeInsets.only(
            bottom: i == _list.length - 1 ? 0 : 16.0,
          ),
          child: listItem(_list.elementAt(i)),
        ),
      );
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 60.0,
            ),
            navbar,
            const SizedBox(
              height: 32.0,
            ),
            tabbar,
            const SizedBox(
              height: 20.0,
            ),
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
