// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../mvp/base_page.dart';
import '../res/colors.dart';
import '../widgets/load_image.dart';
import 'presenter/report_detail_page_presenter.dart';
import 'view/report_detail_view.dart';
import 'widget/advise.dart';
import 'widget/analysis.dart';

class ReportDetailPage extends StatefulWidget {
  const ReportDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> with BasePageMixin<ReportDetailPage, ReportDetailPagePresenter>, AutomaticKeepAliveClientMixin<ReportDetailPage> implements ReportDetailView {

  late ReportDetailPagePresenter _reportDetailPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // evaluation-综合评价 advise-地道表达建议 analysis-细节解析
  String _type = 'evaluation';

  void init() {
    getReportDetail();
  }

  void getReportDetail() {}

  void tapTabbar(String type) {
    _type = type;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double width = _screenUtil.screenWidth - 32.0;

    Widget navbar = Stack(
      children: <Widget>[
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LoadAssetImage(
              'zhuangshi_zuo',
              width: 16.0,
              height: 16.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                '学情报告',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.0,
                  letterSpacing: 0.05,
                ),
              ),
            ),
            LoadAssetImage(
              'zhuangshi_you',
              width: 16.0,
              height: 16.0,
            ),
          ],
        ),
        Positioned(
          left: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: const LoadAssetImage(
              'navbar_back',
              width: 18.2,
              height: 22.0,
            ),
          ),
        ),
      ],
    );

    Widget score = Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.black.withOpacity(0.85),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 48.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '94%',
                style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 19.0 / 40.0,
                ),
              ),
              Text(
                '超过该年龄段用户\n满分为100分',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 19.0 / 14.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20.0,
          ),
          Container(
            width: 128.0,
            height: 128.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/caihuan.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${76}',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 37.5 / 32.0,
                  ),
                ),
                Text(
                  '总分',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 14.0 / 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Widget radar = Container(
      width: width,
      height: 240.0,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/radar_bg.png',
          ),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
    
    Widget schedule = Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: const Color(0xFFE6FAFF),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const LoadAssetImage(
            'jiangzhang',
            width: 48.0,
            height: 48.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: '你当前级别为',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF333333),
                        height: 20.0 / 16.0,
                      ),
                    ),
                    TextSpan(
                      text: '1级\n',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF9900F8),
                        height: 20.0 / 16.0,
                      ),
                    ),
                    TextSpan(
                      text: '已经完成',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                        height: 26.0 / 14.0,
                      ),
                    ),
                    TextSpan(
                      text: '60%',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF0047FF),
                        height: 26.0 / 14.0,
                      ),
                    ),
                    TextSpan(
                      text: '学习进度\n',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                        height: 26.0 / 14.0,
                      ),
                    ),
                    TextSpan(
                      text: '完成剩余',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                        height: 20.0 / 14.0,
                      ),
                    ),
                    TextSpan(
                      text: '40%',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF0047FF),
                        height: 20.0 / 14.0,
                      ),
                    ),
                    TextSpan(
                      text: '的学习进度\n可升至2级，继续加油呀！ ',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF333333),
                        height: 20.0 / 14.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 87.0,
            height: 34.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(
                width: 1.0,
                style: BorderStyle.solid,
                color: const Color(0xFFE49600),
              ),
              color: const Color(0xFFFFCF71),
            ),
            alignment: Alignment.center,
            child: const Text(
              '升级会员',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                letterSpacing: 0.05,
              ),
            ),
          ),
        ],
      ),
    );

    Widget barItem(String label, String type) {
      bool isSelected = _type == type;
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (isSelected) {
            return;
          }
          tapTabbar(type);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: isSelected ? const Color(0xFF000000) : const Color(0xFF333333),
                height: 18.0 / 16.0,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Container(
              width: 56.0,
              height: 3.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: isSelected ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colours.color_9AC3FF,
                    Colours.color_FF71E0,
                  ],
                ) : null,
              ),
            ),
          ],
        ),
      );
    }

    Widget tabbar = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        barItem('综合评价', 'evaluation'),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ),
          child: barItem('地道表达建议', 'advise'),
        ),
        barItem('细节解析', 'analysis'),
      ],
    );

    Widget evaluationItem(String icon, String label, {Widget? child}) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFFF8F8F8),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: Row(
          children: <Widget>[
            LoadAssetImage(
              icon,
              width: 51.0,
              height: 51.0,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                  if (child != null)
                    ...[
                      const SizedBox(
                        width: 8.0,
                      ),
                      child,
                    ],
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget evaluation = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        evaluationItem(
          'fayin',
          '发音',
          child: const Text(
            '发音棒极了，超过90%同学',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 15.0,
              letterSpacing: 0.05,
            ),
          ),
        ),
        evaluationItem(
          'yufa',
          '语法与用词',
          child: const Text(
            '语法与用词需要加强，目前得分80分，超过50%同学',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 15.0,
              letterSpacing: 0.05,
            ),
          ),
        ),
        evaluationItem(
          'liuchangdu',
          '流畅度',
          child: const Text(
            '流畅度得分94，表现优秀，超过90%同学',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 15.0,
              letterSpacing: 0.05,
            ),
          ),
        ),
        evaluationItem(
          'wanzhengdu',
          '完整度',
          child: const Text(
            '句子表述较完整，得分86，超过89%的同学',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w400,
              color: Color(0xFF666666),
              height: 18.0 / 15.0,
              letterSpacing: 0.05,
            ),
          ),
        ),
      ],
    );

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
              height: 12.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      '本次对话${30}个，对话时间：${'2023-09-02'}',
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 18.0 / 14.0,
                        letterSpacing: 0.05,
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    score,
                    const SizedBox(
                      height: 16.0,
                    ),
                    radar,
                    const SizedBox(
                      height: 16.0,
                    ),
                    schedule,
                    const SizedBox(
                      height: 16.0,
                    ),
                    tabbar,
                    const SizedBox(
                      height: 16.0,
                    ),
                    if (_type == 'evaluation')
                      evaluation,
                    if (_type == 'advise')
                      Advise(id: widget.id),
                    if (_type == 'analysis')
                      Analysis(id: widget.id),
                    SizedBox(
                      height: _screenUtil.bottomBarHeight,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ReportDetailPagePresenter createPresenter() {
    _reportDetailPagePresenter = ReportDetailPagePresenter();
    return _reportDetailPagePresenter;
  }

  @override
  bool get wantKeepAlive => false;
}