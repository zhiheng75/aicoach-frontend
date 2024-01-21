// ignore_for_file: prefer_final_fields

import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/util/media_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../net/http_api.dart';
import '../../res/colors.dart';
import '../../widgets/load_data.dart';
import '../../widgets/load_fail.dart';
import '../../widgets/load_image.dart';
import '../entity/analysis_entity.dart';

class Analysis extends StatefulWidget {
  const Analysis({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  final String sessionId;

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {

  final MediaUtils _mediaUtils = MediaUtils();
  final ScreenUtil _screenUtil = ScreenUtil();
  // 状态 loading-加载中 fail-失败 success-成功
  String _state = 'loading';
  final CancelToken _cancelToken = CancelToken();
  List<AnalysisEntity> _analysisList = [];

  void init() {
    _state = 'loading';
    setState(() {});
    getAnalysisList();
  }

  void getAnalysisList() {
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.scoreAnalysis,
      cancelToken: _cancelToken,
      queryParameters: {
        'session_id': widget.sessionId,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _state = 'fail';
          if (mounted) {
            setState(() {});
          }
          return;
        }
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        if (data['sentence_list'] != null && data['sentence_list'] is List) {
          List<AnalysisEntity> analysisList = [];
          for(dynamic item in data['sentence_list']) {
            AnalysisEntity analysis = AnalysisEntity.fromJson(item);
            analysis.type = data['type'] ?? 2;
            if (item['list'] != null && item['list'] is List) {
              List<PronounceEntity> pronounceList = [];
              for(dynamic pronounceItem in item['list']) {
                PronounceEntity pronounce = PronounceEntity.fromJson(pronounceItem);
                pronounceList.add(pronounce);
              }
              analysis.pronounce = pronounceList;
            }
            analysisList.add(analysis);
          }
          _analysisList = analysisList;
        }
        _state = 'success';
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        _state = 'fail';
        if (mounted) {
          setState(() {});
        }
        return;
      },
    );
  }

  void playAudio(String audioUrl) {
    try {
      _mediaUtils.stopPlay();
      _mediaUtils.play(
        url: audioUrl,
      );
    } catch (error) {}
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    if (_state == 'loading') {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_state != 'success') {
      return Padding(
        padding: EdgeInsets.only(
          bottom: _screenUtil.bottomBarHeight + 16.0,
        ),
        child: _state == 'fail' ? LoadFail(
          reload: init,
        ) : const LoadData(),
      );
    }

    Widget analysisItem(AnalysisEntity analysis) {

      Widget session(String label, {required Widget child}) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: label.length * 16.0,
                  height: 12.0,
                  color: const Color(0xFFFFDD9C),
                ),
                Positioned(
                  left: 0,
                  child: Center(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            child,
          ],
        );
      }

      Widget content = const SizedBox();
      if (analysis.type == 1) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _screenUtil.screenWidth - 32.0,
              child: Text(
                analysis.sentence,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 16.0 / 14.0,
                ),
              ),
            ),
            const SizedBox(
              height: 16.0,
            ),
            if (analysis.grammar.isNotEmpty)
              session(
                '语法与句子解析',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: analysis.grammar.map((item) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(
                        bottom: 16.0,
                      ),
                      child: Text(
                        '${item.en} : ${item.zh}',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 20.0 / 15.0,
                          letterSpacing: 0.05,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (analysis.pronounce.isNotEmpty)
              session(
                '发音建议',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: analysis.pronounce.map((item) {
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (item.audio == '') {
                          return;
                        }
                        playAudio(item.audio);
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.white,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          margin: const EdgeInsets.only(
                            bottom: 16.0,
                          ),
                          child: Row(
                            children: [
                              const LoadAssetImage(
                                'laba_lan',
                                width: 17.6,
                                height: 16.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  item.text,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                    height: 20.0 / 15.0,
                                    letterSpacing: 0.05,
                                  ),
                                ),
                              ),
                              const LoadAssetImage(
                                'laba_lan',
                                width: 17.6,
                                height: 16.0,
                              ),
                            ],
                          )
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        );
      }
      if (analysis.type == 2) {
        content = Row(
          children: [
            Expanded(
              child: Text(
                analysis.sentence,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 16.0 / 14.0,
                ),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: '${analysis.score.toInt()}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            height: 24.0 / 14.0,
                            letterSpacing: 0.05,
                          )
                      ),
                      const TextSpan(
                          text: '分',
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF666666),
                            height: 24.0 / 10.0,
                            letterSpacing: 0.05,
                          )
                      ),
                    ],
                  ),
                ),
                const LoadAssetImage(
                  'dianzan',
                  width: 18.0,
                  height: 18.0,
                ),
              ],
            ),
          ],
        );
      }

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: const Color(0xFFF8F8F8),
        ),
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(
          bottom: 16.0,
        ),
        child: content,
      );
    }

    if (_analysisList.isEmpty) {
      return Column(
        children: <Widget>[
          Text(
            '暂无细节解析',
            style: TextStyle(
              fontSize: 15.0,
              color: Colours.hex2color('#546092'),
              letterSpacing: 16.0 / 15.0,
              height: 24.0 / 16.0,
            ),
          ),
          SizedBox(
            height: _screenUtil.bottomBarHeight + 16.0,
          ),
        ],
      );
    }

    return Column(
      children: _analysisList.map((analysis) => analysisItem(analysis)).toList(),
    );
  }
}