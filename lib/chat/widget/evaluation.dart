// ignore_for_file: prefer_final_fields

import 'package:Bubble/chat/entity/message_entity.dart';
import 'package:Bubble/entity/result_entity.dart';
import 'package:Bubble/net/dio_utils.dart';
import 'package:Bubble/net/http_api.dart';
import 'package:Bubble/util/log_utils.dart';
import 'package:Bubble/widgets/load_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  String _standardAnswer = '';
  bool _isGetting = false;

  void init() {
    getStandardAnswer();
  }

  void getStandardAnswer() {
    NormalMessage message = widget.message;
    DioUtils.instance.requestNetwork<ResultData>(
      Method.get,
      HttpApi.suggestAnswer,
      params: {
        'question': message.question,
        'answer': message.text,
        'session_id': message.sessionId,
        'message_id': message.id,
        'character_id': message.characterId,
      },
      onSuccess: (result) {
        if (result == null || result.data == null) {
          _standardAnswer = '获取失败';
          _isGetting = false;
          setState(() {});
          return;
        }
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        _standardAnswer = data['text'];
        _isGetting = false;
        setState(() {});
      },
      onError: (code, msg) {
        Log.d('get standard answer fail:msg=$msg', tag: '获取地道表达');
        _standardAnswer = '获取失败';
        _isGetting = false;
        setState(() {});
      },
    );
  }

  void playVoice(String type) {
  }

  @override
  void initState() {
    super.initState();
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

    Widget evaluate = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      ],
    );

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
              onTap: () => Navigator.of(context).pop(),
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
