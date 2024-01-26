// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:Bubble/util/media_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../entity/result_entity.dart';
import '../../home/provider/home_provider.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../report/widget/radar.dart';
import '../../util/log_utils.dart';
import '../../widgets/load_image.dart';
import '../entity/message_entity.dart';
import '../utils/evaluate_util.dart';

class Evaluation extends StatefulWidget {
  const Evaluation({
    Key? key,
    required this.message,
  }) : super(key: key);

  final NormalMessage message;

  @override
  State<Evaluation> createState() => _EvaluationState();
}

class _EvaluationState extends State<Evaluation> {
  final MediaUtils _mediaUtils = MediaUtils();
  late HomeProvider _homeProvider;
  CancelToken _cancelToken = CancelToken();
  String _standardAnswer = '';
  bool _isGetting = false;
  // tts请求取消
  CancelToken? _ttsCancelToken;
  String _audioType = '';

  void init() {
    EvaluateUtil().evaluate(widget.message, () {
      _homeProvider.updateNormalMessage(widget.message);
    });
    getStandardAnswer();
  }

  void getStandardAnswer() {
    if (widget.message.question == '') {
      _standardAnswer = '暂无地道表达';
      _isGetting = false;
      if (mounted) {
        setState(() {});
      }
      return;
    }
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.suggestAnswer,
      params: {
        'question': widget.message.question,
        'answer': widget.message.text,
        // 'session_id': _homeProvider.sessionId,
        // 'message_id': widget.message.questionMessageId,
        'character_id': _homeProvider.character.characterId,
      },
      cancelToken: _cancelToken,
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _standardAnswer = '获取失败';
          _isGetting = false;
          if (mounted) {
            setState(() {});
          }
          return;
        }
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        _standardAnswer = data['text'];
        _isGetting = false;
        if (mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        Log.d('get standard answer fail:msg=$msg', tag: '获取地道表达');
        _standardAnswer = '获取失败';
        _isGetting = false;
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  void playVoice(String type) async {
    _audioType = type;
    if (_ttsCancelToken != null) {
      _ttsCancelToken!.cancel();
      _ttsCancelToken = null;
    }
    await _mediaUtils.stopPlay();
    if (type == 'user') {
      _mediaUtils.play(
        pcmBuffer: widget.message.audio,
      );
    }
    if (type == 'standard') {
      _ttsCancelToken = CancelToken();
      DioUtils.instance.requestNetwork<ResultData>(
        Method.post,
        HttpApi.generateAudio,
        params: {
          'text': widget.message.text,
        },
        onSuccess: (result) {
          _ttsCancelToken = null;
          if (result == null || result.data == null || (result.data as Map<String, dynamic>)['speech_url'] == null) {
            return;
          }
          if (_audioType == 'standard') {
            Map<String, dynamic> data = result.data as Map<String, dynamic>;
            _mediaUtils.play(
              url: data['speech_url'],
            );
          }
        },
        onError: (code, msg) {
          _ttsCancelToken = null;
        }
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    init();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil screenUtil = ScreenUtil();
    NormalMessage message = widget.message;

    Widget voiceButton(String label, String type) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => playVoice(type),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                letterSpacing: 0.05,
              ),
            ),
            const SizedBox(
              width: 16.0,
            ),
            const LoadAssetImage(
              'laba_zhi',
              width: 17.6,
              height: 16.0,
            ),
          ],
        ),
      );
    }

    Widget evaluate = const SizedBox();
    if (widget.message.evaluation.isNotEmpty) {
      Map<String, dynamic> evaluation = widget.message.evaluation;
      RadarItem top = RadarItem('完整度', double.parse(evaluation['integrity_score']), const Color(0xFF6195D2));
      RadarItem bottom = RadarItem('流畅度', double.parse(evaluation['fluency_score']), const Color(0xFFFF71CF));
      RadarItem left = RadarItem('发音', double.parse(evaluation['standard_score']), const Color(0xFFB3E3FF));
      RadarItem right = RadarItem('语法', double.parse(evaluation['accuracy_score']), const Color(0xFFFFD076));
      List<RadarItem> scoreList = [
        top,
        bottom,
        left,
        right,
      ];
      evaluate = Container(
        height: sqrt(5000) * 2.5,
        padding: const EdgeInsets.symmetric(
          vertical: 24.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: scoreList.map((item) {
                return Row(
                  children: <Widget>[
                    Container(
                      width: 9.0,
                      height: 9.0,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                          style: BorderStyle.solid,
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(9.0),
                        color: item.color,
                      ),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        height: 22.0 / 13.0,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
            Container(
              width: sqrt(5000) * 3,
              alignment: Alignment.center,
              child: Radar(
                r: sqrt(5000),
                top: top,
                bottom: bottom,
                left: left,
                right: right,
                scoreStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 12.0 / 16.0,
                ),
                labelStyle: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  height: 1.0,
                ),
                source: 'evaluation',
              ),
            )
          ],
        ),
      );
    }

    return Container(
      width: screenUtil.screenWidth,
      height: screenUtil.screenHeight,
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
            ),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (_isGetting) {
                  _cancelToken.cancel();
                }
                Navigator.of(context).pop();
              },
              child: const LoadAssetImage(
                'reminder_close',
                width: 32.0,
                height: 32.0,
              ),
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/evaluation_bg.png',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    message.text,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      height: 16.0 / 12.0,
                      letterSpacing: 0.05,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      voiceButton('标准这样读', 'standard'),
                      const SizedBox(
                        width: 24.0,
                      ),
                      voiceButton('我这样读', 'user')
                    ],
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  evaluate,
                  const SizedBox(
                    height: 16.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        '地道表达',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          height: 21.0 / 15.0,
                          letterSpacing: 0.05,
                        ),
                      ),
                      Text(
                        _isGetting ? '获取中...' : _standardAnswer,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          height: 21.0 / 14.0,
                          letterSpacing: 0.05,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: screenUtil.bottomBarHeight + 16.0,
          ),
        ],
      ),
    );
  }
}
