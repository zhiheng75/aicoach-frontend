// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/report/widget/radar.dart';
import 'package:Bubble/report/widget/score.dart';
import 'package:Bubble/util/device_utils.dart';
import 'package:Bubble/widgets/load_data.dart';
import 'package:Bubble/widgets/load_fail.dart';
import 'package:dio/dio.dart';
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
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage>
    with
        BasePageMixin<ReportDetailPage, ReportDetailPagePresenter>,
        AutomaticKeepAliveClientMixin<ReportDetailPage>
    implements ReportDetailView {
  late ReportDetailPagePresenter _reportDetailPagePresenter;
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _pageState = 'loading';
  final CancelToken _cancelToken = CancelToken();
  Map<String, dynamic> _detail = {};
  // evaluation-综合评价 advise-地道表达建议 analysis-细节解析
  String _type = 'evaluation';

  void init() {
    _pageState = 'loading';
    setState(() {});
    getReportDetail();
  }

  void getReportDetail() async {
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.coinReport,
      queryParameters: {
        'session_id': widget.sessionId,
        'device_id': await Device.getDeviceId(),
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _pageState = 'fail';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        _detail = result.data as Map<String, dynamic>;
        _pageState = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        _pageState = 'fail';
        if (mounted) {
          setState(() {});
        }
      }
    );
  }

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
  void dispose() {
    if (_pageState == 'loading') {
      _cancelToken.cancel();
    }
    super.dispose();
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
                  height: 22.0 / 18.0,
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
          top: 0,
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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _detail['rank'] ?? '0%',
                style: const TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 19.0 / 40.0,
                ),
              ),
              const Text(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${((_detail['total_score'] ?? 0) as num).toInt()}',
                  style: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    height: 37.5 / 32.0,
                  ),
                ),
                const Text(
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
      alignment: Alignment.center,
      child: _detail.isNotEmpty ? Radar(
        r: sqrt(5000),
        top: RadarItem('完整度', _detail['integrity_score']),
        bottom: RadarItem('流畅度', _detail['fluency_score']),
        left: RadarItem('发音', _detail['standard_score']),
        right: RadarItem('语法', _detail['accuracy_score']),
        scoreStyle: const TextStyle(
          fontSize: 22.0,
          fontWeight: FontWeight.w700,
          color: Colors.black,
          height: 25.7 / 22.0,
        ),
        labelStyle: const TextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
          color: Colors.black,
          height: 14.0 / 12.0,
        ),
      ) : const SizedBox(),
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
                color: isSelected
                    ? const Color(0xFF000000)
                    : const Color(0xFF333333),
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
                gradient: isSelected
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colours.color_9AC3FF,
                          Colours.color_FF71E0,
                        ],
                      )
                    : null,
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

    Widget content = const SizedBox();
    if (_pageState != 'success') {
      content = Expanded(
        child: Center(
          child: _pageState == 'fail' ? LoadFail(reload: init) : const LoadData(),
        ),
      );
    } else {
      content = Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                '本次对话${_detail['session_count']}个，对话时间：${_detail['session_time'] ?? ''}',
                style: const TextStyle(
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
              if (_type == 'evaluation') Score(sessionId: widget.sessionId),
              if (_type == 'advise') Advise(sessionId: widget.sessionId),
              if (_type == 'analysis') Analysis(sessionId: widget.sessionId),
              SizedBox(
                height: _screenUtil.bottomBarHeight,
              ),
            ],
          ),
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
              height: 12.0,
            ),
            content,
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
