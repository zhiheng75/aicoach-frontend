// ignore_for_file: prefer_final_fields

import 'dart:typed_data';

import 'package:Bubble/util/media_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../entity/result_entity.dart';
import '../../home/provider/home_provider.dart';
import '../../net/dio_utils.dart';
import '../../net/http_api.dart';
import '../../report/widget/radar_map.dart';
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

  void init() {
    EvaluateUtil().evaluate(widget.message, () {
      _homeProvider.updateNormalMessage(widget.message);
    });
    getStandardAnswer();
  }

  void getStandardAnswer() {
    DioUtils.instance.requestNetwork<ResultData>(
      Method.post,
      HttpApi.suggestAnswer,
      params: {
        'question': widget.message.question,
        'answer': widget.message.text,
        'session_id': _homeProvider.sessionId,
        'message_id': widget.message.questionMessageId,
        'character_id': _homeProvider.character.characterId,
      },
      cancelToken: _cancelToken,
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _standardAnswer = '获取失败';
          _isGetting = false;
          if (!mounted) {
            setState(() {});
          }
          return;
        }
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        _standardAnswer = data['text'];
        _isGetting = false;
        if (!mounted) {
          setState(() {});
        }
      },
      onError: (code, msg) {
        Log.d('get standard answer fail:msg=$msg', tag: '获取地道表达');
        _standardAnswer = '获取失败';
        _isGetting = false;
        if (!mounted) {
          setState(() {});
        }
      },
    );
  }

  void playVoice(String type) async {
    await _mediaUtils.stopPlayLoop(true);
    if (type == 'user') {
      List<int> bytes = [];
      List<Uint8List> bufferList = widget.message.audio;
      for (Uint8List element in bufferList) {
        bytes.addAll(element.map((item) => item).toList());
      }
      _mediaUtils.play(
        buffer: _mediaUtils.toWav(bytes),
        whenFinished: () {
          _mediaUtils.resumeUse();
        },
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
      List<RadarBean> scoreList = [
        RadarBean(double.parse(evaluation['accuracy_score']), '发音'),
        RadarBean(double.parse(evaluation['standard_score']), '语法'),
        RadarBean(double.parse(evaluation['integrity_score']), '完整度'),
        RadarBean(double.parse(evaluation['fluency_score']), '流畅度'),
      ];
      evaluate = Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
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
                      ),
                    ),
                    const SizedBox(
                      width: 6.0,
                    ),
                    Text(
                      item.name,
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
            RadarMap(
              scoreList,
              r: 54.8,
            ),
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
